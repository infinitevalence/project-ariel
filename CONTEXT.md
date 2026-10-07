Push 3 8f7652f compiles clean and lands both round-2 fixes, but carries two new blockers - one hangs boot in governor mode, one reopens the double-writer wedge.

What checks out
cargo check -p apu --all-targets on 8f7652f here: clean. The newline-split bug is gone - start-stop-daemon lines now emit real backslash continuations (persist.rs:254, :260). enabled() reads /etc/runlevel/default/{rc} (persist.rs:328), so the legacy-unit guard works again.

Blocker 1 - the force_mhz grep matches every power.json.
PowerConfig::save writes serde_json::to_string_pretty(self) (dpm.rs:217) and force_mhz is an Option<u32> with no skip_serializing_if (dpm.rs:83) - auto mode still serializes "force_mhz": null. So grep -q "force_mhz" (persist.rs:243) is always true, the sync branch always fires, and gpu apply-boot runs the governor in-process (cli.rs:329) inside start() - OpenRC start never returns on a governor-mode boot. This is from reading the source; confirm it on your Alpine box. Match the value, not the key:

grep -Eq '"force_mhz"[[:space:]]*:[[:space:]]*[0-9]' /var/lib/aputune/power.json


or drop null keys with #[serde(skip_serializing_if = "Option::is_none")].

Blocker 2 - the backgrounded daemon has no stop() and no pidfile.
The generated script defines only start(), and --background without --make-pidfile never writes /run/{name}.pid. Stop/restart cannot reap the old governor, so a restart starts a second SMU writer - the round-1 wedge class, only half fixed. Add --make-pidfile (consider --wait) and emit:

stop() {
        ebegin
        start-stop-daemon --stop --pidfile "$pidfile"
        eend $?
}


Nothing pins the generated script text yet; one string test asserting both fixes would have caught blocker 1 - and it must fail with the fix reverted.


@infinitevalence Not good to merge yet - push 3 8f7652f still has two blockers, and both are OpenRC-only paths, which is why your testing looks clean.

The full round-3 review is the post right above this one. Short version:

grep -q "force_mhz" matches EVERY power.json, because serde serializes "force_mhz": null in auto mode (dpm.rs:83, no skip_serializing_if). The sync branch always fires and gpu apply-boot runs the governor in-process inside start() - a governor-mode Alpine boot hangs there.
The generated script defines only start(), and --background without --make-pidfile never writes /run/{name}.pid, so stop/restart cannot reap the old governor - a restart starts a second SMU writer.

What is solid: cargo check -p apu --all-targets is clean at 8f7652f, the newline-split fix is correct, and the enabled() runlevel path holds.

For your Alpine user: point them at your fork at 8f7652f and tell them to use a manual clock pin (apu gpu clock set) rather than governor mode until blocker 1 is fixed - manual pin is exactly the branch that works today. Push the two fixes and I will re-run the checks here, then we can talk merge.
