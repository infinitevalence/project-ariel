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
