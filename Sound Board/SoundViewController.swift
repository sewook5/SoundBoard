//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Matthew Oh on 6/5/17.
//  Copyright © 2017 BB Inc. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isEnabled = false
        addButton.isEnabled = false
        setupRecorder()
        
    }
    
    func setupRecorder() {
        
        do {
            // Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // Create URL for the audio file
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            //print("#################################")
            //print(audioURL) //getting the directory where the audio file is saved
            //print("#################################")
            // Create settings for the audio recorder
            
            var settings : [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            // Create AudioRecorder object
            try audioRecorder = AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            
            print(error)
            
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            
            //Stop the recording
            audioRecorder?.stop()
            
            //Change button title to "Record"
            recordButton.setTitle("Record", for: .normal)
            
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        } else {
            //Start the recording
            audioRecorder?.record()
            
            //Change button title to "Stop"
            recordButton.setTitle("Stop", for: .normal)
            
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
            
        } catch {}
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true) //Return to the tableview once addbutton is hitted
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
