//
//  ViewController.swift
//  ReadMe
//
//  Created by Mehmet Deniz Cengiz on 11/1/20.
//  Copyright © 2020 Deniz Cengiz. All rights reserved.
//

import UIKit

class LibraryHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "\(LibraryHeaderView.self)"
    @IBOutlet var titleLabel: UILabel!
}

enum Section: String, CaseIterable {
    case addNew
    case readMe = "Read Me!"
    case finished = "Finished!"
}

class LibraryViewController: UITableViewController {
   
    var dataSource: LibraryDataSource!

    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow,
        let book = dataSource.itemIdentifier(for: indexPath)
        else { fatalError() }

        return DetailViewController(coder: coder, book: book)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
       
        tableView.register(UINib(nibName: "\(LibraryHeaderView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
        configureDataSource()
        dataSource.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.update()
    }
    
    //MARK:- Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Read Me!" : nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LibraryHeaderView.reuseIdentifier) as? LibraryHeaderView else { return nil }
        headerView.titleLabel.text = Section.allCases[section].rawValue
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? 60 : 0
    }
    //MARK:- DataSource
    
    func configureDataSource() {
        dataSource = LibraryDataSource(tableView: tableView) { (tableView, indexPath, book) -> UITableViewCell? in
            if indexPath == IndexPath(row: 0, section: 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else {
                fatalError("Could not create Book")
            }
            cell.titleLabel.text = book.title
            cell.authorLabel.text = book.author
            cell.bookThumbnail.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
            cell.bookThumbnail.layer.cornerRadius = 12
            if let review = book.review {
                cell.reviewLabel.text = review
                cell.reviewLabel.isHidden = false
            }
            cell.readMeBookmark.isHidden = !book.readMe
            
            return cell
        }
    }
    
    func updateDataSource() {
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        newSnapshot.appendSections(Section.allCases)
        let booksByReadMe: [Bool: [Book]] = Dictionary(grouping: Library.books, by: \.readMe)
        for (readMe, books) in booksByReadMe {
            newSnapshot.appendItems(books, toSection: readMe ? .readMe : .finished)
        }
        newSnapshot.appendItems([Book.mockBook], toSection: .addNew)
        dataSource.apply(newSnapshot, animatingDifferences: true)
    }
    
}

class LibraryDataSource: UITableViewDiffableDataSource<Section, Book> {
    func update() {
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        newSnapshot.appendSections(Section.allCases)
        let booksByReadMe: [Bool: [Book]] = Dictionary(grouping: Library.books, by: \.readMe)
        for (readMe, books) in booksByReadMe {
            newSnapshot.appendItems(books, toSection: readMe ? .readMe : .finished)
        }
        newSnapshot.appendItems([Book.mockBook], toSection: .addNew)
        apply(newSnapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == snapshot().indexOfSection(.addNew) ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let book = self.itemIdentifier(for: indexPath) else { return }
            Library.delete(book: book)
            update()
        }
    }
}

