//
//  DetailViewController.swift
//  pokeBook
//
//  Created by 내꺼다 on 8/7/24.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!
    let disposeBag = DisposeBag()
    
    let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
        
        view.addSubview(infoContainerView)
        infoContainerView.addSubview(pokemonImageView)
        infoContainerView.addSubview(nameLabel)
        infoContainerView.addSubview(typeLabel)
        infoContainerView.addSubview(heightLabel)
        infoContainerView.addSubview(weightLabel)
        
        setupConstraints()
        
        viewModel.pokemonDetail.subscribe(onNext: { [weak self] detail in
            self?.nameLabel.text = "No.\(detail.id)  " + detail.localizedName
            let types = detail.localizedTypes().first ?? "Unknown"
            self?.typeLabel.text = "타입: \(types)"
            // 키랑 몸무게 그냥 앞에 0.몇 으로 넣는게 아닌 소수점 위치 지정
            let heightInMeters = Double(detail.height) / 10.0
            let weightInKg = Double(detail.weight) / 10.0
            self?.heightLabel.text = "키: \(heightInMeters) m"
            self?.weightLabel.text = "몸무게: \(weightInKg) kg"
            
            Task {
                let image = await self?.viewModel.loadImage(for: detail.id)
                self?.pokemonImageView.image = image
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            infoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            infoContainerView.heightAnchor.constraint(equalToConstant: 350),
            
            pokemonImageView.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 20),
            pokemonImageView.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 150),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 150),
            
            
            nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typeLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            
            heightLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            heightLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            
            weightLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 10),
            weightLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
        ])
    }
}
