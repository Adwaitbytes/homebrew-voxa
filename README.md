# homebrew-voxa

Homebrew tap for [Voxa](https://srv1145523.hstgr.cloud/) — a voice-to-action Mac agent.

## Install

```bash
brew install --cask Adwaitbytes/voxa/voxa
```

That's it. Brew installs `cloudflared` (a dependency) and Voxa, strips the macOS quarantine attribute so Gatekeeper doesn't block first launch, and you're ready.

## What you get

- Voice → action across any Mac app (WhatsApp, Notion, Gmail, YouTube, browser, smart home)
- Wake word ("saara") + push-to-talk hotkey
- 21+ MCP integrations (Slack, Notion, GitHub, Chrome DevTools, Linear, etc.)
- Vision (look at screen + answer)
- Meetings mode (system-audio capture + auto summary + action items)
- Interview mode (Cluely-style invisible overlay)
- Voice clone (ElevenLabs)
- Memory across sessions
- India-native defaults (₹, IST, IPL, +91)

## First launch — grant these macOS permissions

When you first open Voxa, macOS will prompt for each:
- **Accessibility** — hotkey, WhatsApp send, window mgmt
- **Microphone** — wake word + voice capture
- **Speech Recognition** — STT + meetings
- **Screen Recording** — meetings + interview mode

Voxa pops alerts walking you through each. Accessibility is the only one you have to add manually (no system popup) — Voxa opens the Privacy pane for you.

## After Voxa updates — TCC reset trap

Every Voxa update changes its codesign hash, so macOS treats it as a new app and silently keeps the old permission entries. After a `brew upgrade`:

```bash
tccutil reset Accessibility ai.voxa.macos
tccutil reset Microphone ai.voxa.macos
tccutil reset SpeechRecognition ai.voxa.macos
tccutil reset ScreenCapture ai.voxa.macos
pkill -f Voxa.app && open /Applications/Voxa.app
```

Mic / Speech / Screen Recording auto-prompt fresh. Re-add Voxa to Accessibility manually — Voxa pops an alert opening the right pane.

This goes away once we enroll in Apple Developer ID.

## Try it

After install, click the Voxa icon in your menu bar. Then say:
- "saara what time is it"
- "saara open whatsapp and send hi to ayush"
- "saara what's my battery"
- "saara take a screenshot"

## Update

```bash
brew upgrade --cask voxa
```

## Uninstall

```bash
brew uninstall --cask voxa             # removes the app + tunnel script + launchd job
brew uninstall --cask voxa --zap       # also wipes user data + caches
```

## Per-user privacy

Each Voxa install on each Mac is fully isolated. The app contains no per-user data — first launch on a new Mac creates a fresh identity automatically. See https://srv1145523.hstgr.cloud/dl/ for details.

## Issues

File issues at https://github.com/Adwaitbytes/homebrew-voxa/issues
