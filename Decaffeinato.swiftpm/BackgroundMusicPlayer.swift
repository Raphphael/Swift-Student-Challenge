import AVFoundation

class BackgroundMusicPlayer {
    var audioPlayer: AVAudioPlayer?
    var url : String = ""
    
    func playBackgroundMusic(backgroundSelection : String) {
        if(backgroundSelection == "background_coffeeshop"){
            url = "quiet-cafe-chatter-milk-frothing-machine-atmos-atmosphere-wildtrack-ambience-24034"
        }
        if(backgroundSelection == "background_forest"){
            url = "amazon-jungle-day-crickets-birds-and-frogs-from-boat-on-river-great-spread2-some-occasional-boat-rocking-52759"
        }
        guard let url = Bundle.main.url(forResource: url, withExtension: "mp3") else {
            print("Could not find music file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not play music file: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
}

