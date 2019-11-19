workflow "check for flood" {
  on = "schedule(23 * * * *)"
  resolves = "check-flood"
}
action "check-flood" {
    uses = "./.github/check-flood"
    secrets = ["GITHUB_TOKEN"]
}
