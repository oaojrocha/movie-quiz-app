//
//  ViewController.swift
//  MovieQuiz
//
//  Created by School Picture Dev on 21/05/18.
//  Copyright © 2018 Joao Rocha. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var viSoundBar: UIView!
    @IBOutlet weak var slMusic: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var ivQuiz: UIImageView!
    @IBOutlet weak var viTimer: UIView!
    
    var quizManager: QuizManager!
    var quizPlayer: AVAudioPlayer!
    var playerItem: AVPlayerItem!
    var backgroundMusicPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundMusic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager = QuizManager()
        getNewQuiz()
        startTimer()
    }
    
    func getNewQuiz() {
        let round = quizManager.generateRandomQuiz()
        for i in 0..<round.options.count {
            btOptions[i].setTitle(round.options[i].name, for: .normal)
        }
        playQuiz()
    }

    @IBAction func checkAnswer(_ sender: UIButton) {
        quizManager.checkAnswer(sender.title(for: .normal)!)
        getNewQuiz()
    }
    
    @IBAction func showHideSoundBar(_ sender: UIButton) {
        viSoundBar.isHidden = !viSoundBar.isHidden
    }
    
    @IBAction func playQuiz() {
        guard let round = quizManager.round else {return}
        ivQuiz.image = UIImage(named: "movieSound")
        if let url = Bundle.main.url(forResource: "quote\(round.quiz.number)", withExtension: "mp3") {
            do {
                self.quizPlayer = try  AVAudioPlayer(contentsOf: url)
                self.quizPlayer.volume = 1
                self.quizPlayer.delegate = self
                self.quizPlayer.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func startTimer() {
        viTimer.frame = view.frame
        UIView.animate(withDuration: 60.0, delay: 0.0, options: .curveLinear, animations: {
            self.viTimer.frame.size.width = 0
            self.viTimer.frame.origin.x = self.view.center.x
        }) { (success) in
            self.gameOver()
        }
    }
    
    func gameOver() {
        quizPlayer.stop()
        performSegue(withIdentifier: "gameOverSegue", sender: nil)
    }
    
    @IBAction func changeMusicTime(_ sender: UISlider) {
        backgroundMusicPlayer.seek(to: CMTime(seconds: Double(sender.value) * playerItem.duration.seconds, preferredTimescale: 1))
    }
    
    @IBAction func changeMusicStatus(_ sender: UIButton) {
        if backgroundMusicPlayer.timeControlStatus == .paused {
            backgroundMusicPlayer.play()
            sender.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            backgroundMusicPlayer.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    func playBackgroundMusic() {
        let url = Bundle.main.url(forResource: "MarchaImperial", withExtension: "mp3")!
        playerItem = AVPlayerItem(url: url)
        backgroundMusicPlayer = AVPlayer(playerItem: playerItem)
        backgroundMusicPlayer.volume = 0.1
        backgroundMusicPlayer.play()
        backgroundMusicPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: nil) { (cmtime) in
            let percent = cmtime.seconds / self.playerItem.duration.seconds
            self.slMusic.setValue(Float(percent), animated: true)
            
            if (percent > 0.999) {
                self.slMusic.setValue(Float(0), animated: true)
                self.backgroundMusicPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameOverViewController
        vc.score = quizManager.score
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ivQuiz.image = UIImage(named: "movieSoundPause")
    }
}
