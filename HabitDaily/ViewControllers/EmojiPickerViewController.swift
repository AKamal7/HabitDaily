//
//  EmojiPickerViewController.swift
//  HabitDaily
//
//  Created by ahmedkamal on 18/05/2025.
//

import UIKit

protocol EmojiPickerDelegate: AnyObject {
    func emojiPicker(_ picker: EmojiPickerViewController, didSelect emoji: String)
}

class EmojiPickerViewController: UIViewController {

    weak var delegate: EmojiPickerDelegate?

    private let categories: [String: [String]] = [
        "😀": ["😀", "😅", "😂", "🤣", "😍", "😎", "😭", "😡"],
        "📚": ["📚", "✏️", "📖", "📝", "🧠", "🎓", "🖊️", "📐", "📅", "⏳", "💡", "🖋️", "🗂️", "📓", "📎", "🧑‍🏫", "🏫"],
        "🍎": ["🍎", "🍔", "🍕", "🍩", "🍇", "🍣", "🥗", "🍪", "🍑"],
        "🏋️": ["💪", "🏃", "🏋️", "🚴", "🏊", "🤸", "🧘", "🥇"],
        "🙏": ["🙏", "🕊️", "✨", "⛪", "🕌", "📿", "🕯️", "🛐", "☪️", "✡️", "✝️", "🕉️"],
        "🌧": ["🌞", "🌧", "❄️", "🌈", "🌲", "🌻", "🌊", "🌙"]
        
        
    ]

    private var selectedCategory: String {
        didSet { collectionView.reloadData() }
    }

    private let collectionView: UICollectionView
    private let segmentedControl: UISegmentedControl

    init() {
        selectedCategory = Array(categories.keys)[0]

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        segmentedControl = UISegmentedControl(items: Array(categories.keys))
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 320, height: 300)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segmentedControl)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }

    @objc func categoryChanged() {
        selectedCategory = Array(categories.keys)[segmentedControl.selectedSegmentIndex]
    }
}

extension EmojiPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[selectedCategory]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let emoji = categories[selectedCategory]?[indexPath.item] ?? "❓"
        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let emoji = categories[selectedCategory]?[indexPath.item] {
            delegate?.emojiPicker(self, didSelect: emoji)
            dismiss(animated: true)
        }
    }
}
