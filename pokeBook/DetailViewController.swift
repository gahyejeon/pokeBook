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
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        infoContainerView.addSubview(idLabel)
        infoContainerView.addSubview(nameLabel)
        infoContainerView.addSubview(typeLabel)
        infoContainerView.addSubview(heightLabel)
        infoContainerView.addSubview(weightLabel)
        
        setupConstraints()
        
        viewModel.pokemonDetail.subscribe(onNext: { [weak self] detail in
            self?.idLabel.text = "No. \(detail.id)"
            self?.nameLabel.text = detail.localizedName
            let types = detail.localizedTypes().first ?? "Unknown"
            self?.typeLabel.text = "타입: \(types)"
            self?.heightLabel.text = "키: 0.\(detail.height) m"
            self?.weightLabel.text = "몸무게: 0.\(detail.weight) kg"
            
            self?.loadImage(for: detail.id)
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
            
            idLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 10),
            idLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor, constant: -40),
            
            nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor, constant: 40),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typeLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            
            heightLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            heightLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            
            weightLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 10),
            weightLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
        ])
    }
    
    private func loadImage(for id: Int) {
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert data to image")
                return
            }
            
            DispatchQueue.main.async {
                self?.pokemonImageView.image = image
            }
        }.resume()
    }
}
