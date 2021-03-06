//
//  GameOverViewController.swift
//  MovieQuiz
//
//  Created by School Picture Dev on 21/05/18.
//  Copyright © 2018 Joao Rocha. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var lbScore: UILabel!
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbScore.text = "\(score)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playAgain(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
