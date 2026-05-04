cask "voxa" do
  version "0.1.0"
  sha256 "90a119d6f003bf850ef5dbf91fa1462ad354550bbe91bdd6efd0e1d557615ce0"

  url "https://srv1145523.hstgr.cloud/dl/Voxa-#{version}.dmg",
      verified: "srv1145523.hstgr.cloud/dl/"
  name "Voxa"
  desc "Voice-to-action Mac agent — speak in any app, Saara does it"
  homepage "https://srv1145523.hstgr.cloud/"

  # Voxa needs cloudflared to expose the local tool server to the backend.
  # Brew auto-installs this dependency before Voxa, so users get a fully
  # working install in one command. cloudflared is a brew FORMULA (CLI),
  # NOT a cask — getting this wrong fails install with "Cask cloudflared
  # is unavailable" (bug 2026-05-05).
  depends_on formula: "cloudflared"
  depends_on macos: ">= :sonoma"

  app "Voxa.app"

  # Strip macOS quarantine attr so first-launch Gatekeeper warning never
  # shows. Brew sets quarantine=false by default for casks installed via
  # brew (vs Safari/Chrome download), but this guarantees it for users
  # who install via `brew install --cask` from any source.
  postflight do
    system_command "/usr/bin/xattr",
                   args:    ["-dr", "com.apple.quarantine", "#{appdir}/Voxa.app"],
                   sudo:    false
  end

  uninstall quit:       "ai.voxa.macos",
            launchctl:  "ai.voxa.tunnel",
            delete:     [
              "~/Library/LaunchAgents/ai.voxa.tunnel.plist",
              "~/.local/bin/voxa-tunnel.sh",
            ]

  zap trash: [
    "~/Library/Application Support/ai.voxa.macos",
    "~/Library/Caches/ai.voxa.macos",
    "~/Library/HTTPStorages/ai.voxa.macos",
    "~/Library/Preferences/ai.voxa.macos.plist",
    "~/Library/Saved Application State/ai.voxa.macos.savedState",
    "/tmp/voxa-tool-token",
    "/tmp/voxa-tool-port",
    "/tmp/voxa-tunnel-url",
    "/tmp/voxa.log",
    "/tmp/voxa-tunnel-launchd.log",
    "/tmp/cloudflared.log",
  ]

  caveats <<~EOS
    Voxa needs these macOS permissions on first launch — grant ALL:
      • Accessibility       (hotkey, WhatsApp send, window mgmt)
      • Microphone          (wake word + voice capture)
      • Speech Recognition  (STT + meetings)
      • Screen Recording    (meetings + interview mode)

    On Voxa updates, the codesign hash changes and macOS silently keeps
    the OLD permission entries. Reset them with:

      tccutil reset Accessibility ai.voxa.macos
      tccutil reset Microphone ai.voxa.macos
      tccutil reset SpeechRecognition ai.voxa.macos
      tccutil reset ScreenCapture ai.voxa.macos
      pkill -f Voxa.app && open /Applications/Voxa.app

    Once running, click the menu bar Voxa icon to start. Try saying:
      "saara what time is it"
      "saara open whatsapp and send hi to ayush"

    Full docs: https://srv1145523.hstgr.cloud/dl/
  EOS
end
