//
//  PlayerViewController.swift
//  KKBoxPart2
//
//  Created by Woody on 2022/6/26.
//

import UIKit
import Combine

class PlayerViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    
    let contentView: PlayerContentView = PlayerContentView()
    
    var playerControll: PodcastsPlayController?
    
    var isNotBuffering : Bool = true
    
    convenience init(_ control: PodcastsPlayController, _ media: PlayerMediaInfo, _ list: [PlayerMediaInfo]) {
        self.init()
        playerControll = control
        playerControll?.load(mediaInfoList: list, playId: media.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confiugreUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func confiugreUI() {
        view.backgroundColor = .white
        view.addSubview(contentView)
        view.backgroundColor = .white
        contentView.fullSuperview()
        
        contentView.sliderBar.addTarget(self, action: #selector(silderAction), for: .valueChanged)
        contentView.playBtn.addTarget(self, action: #selector(playBtnAction), for: .touchUpInside)
        contentView.backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        contentView.nextBtn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
    }
    
    private func binding() {
        playerControll?.currentMedia
            .receive(on: RunLoop.main)
            .sink(receiveValue: contentView.setData(_:))
            .store(in: &bag)
        
        playerControll?.pocastState
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return !self.contentView.sliderBar.isHighlighted
            }
            .throttle(for: .seconds(0.5),scheduler: RunLoop.main, latest: true)
            .sink(receiveValue: {  [weak self] state in
                guard let self = self,
                      let state = state,
                      !self.contentView.sliderBar.isHighlighted else { return }
                if self.contentView.sliderBar.maximumValue != Float(state.duration) {
                    self.contentView.sliderBar.maximumValue = Float(state.duration)
                }
                self.contentView.sliderBar.setValue(Float(state.position), animated: true)
            })
            .store(in: &bag)
        
        playerControll?.playerState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] playerState in
                self?.changePlayBtn(playerState)
            }).store(in: &bag)
        
        playerControll?.playerState
            .filter { $0 == .failed }
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.errorHandler()
            }).store(in: &bag)
        
    }
    
    @objc private func silderAction(_ silder: UISlider) {
        playerControll?.seek(position: Double(silder.value))
    }
    
    private func changePlayBtn(_ state: PlayerState) {
        let isEnabled = !(state == .loading || state == .buffering)
        contentView.playBtn.isEnabled = isEnabled
        contentView.nextBtn.isEnabled = isEnabled
        contentView.backBtn.isEnabled = isEnabled
        
        let image: UIImage? = state == .canPause ? UIImage(systemName: "pause.circle") : UIImage(systemName: "play.circle")
        contentView.playBtn.setBackgroundImage(image, for: .normal)
        contentView.playBtn.setBackgroundImage(image?.sd_resizedImage(with: .init(width: 100, height: 100), scaleMode: .aspectFit)?.sd_tintedImage(with: UIColor.lightGray), for: .highlighted)
    }
    
    private func errorHandler() {
        let alertVC = UIAlertController(title: "問題", message: "發生問題，請稍候再試。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func playBtnAction() {
        guard let state = playerControll?.playerState.value else { return }
        let isPause = state == .canPause
        if isPause {
            playerControll?.pause()
            return
        }
        playerControll?.play(playerControll?.currentMedia.value?.id)
    }
    
    @objc private func nextBtnAction() {
        playerControll?.next()
    }
    
    @objc private func backBtnAction() {
        playerControll?.back()
    }
    
}
