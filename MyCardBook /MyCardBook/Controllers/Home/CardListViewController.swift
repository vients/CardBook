//
//  ViewController.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/27/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit
import CoreData
import MessageUI


class CardListViewController: UIViewController, UIPopoverPresentationControllerDelegate,  UISearchResultsUpdating, SortCardListDelegate {
    struct Constant {
        struct cellIdentifier {
            static let cardListCell = "Cell"
        }
        struct segue {
            
        }
    }
    private var cards = [Card]()
    private var searchResult: [Card] = []
    private var searchController : UISearchController!
    var manager = Manager()
    private var refresher: UIRefreshControl!
    
    @IBOutlet private weak var cardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let logo = UIImage(named: "cardLogo.png")
        //        let imageView = UIImageView(image:logo)
        //        self.navigationItem.titleView = imageView
        addLogoToNavigationBar(logo: "123.png")
        searchControll()
        refreshTable()
        estimateRow()
        
    }
    
    func searchControll() {
        searchController = UISearchController(searchResultsController: nil)
        cardTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.3854118586, green: 0.4650006294, blue: 0.5648224354, alpha: 1)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search card..."
    }
    
    func refreshTable()
    {
        refresher = UIRefreshControl()
        cardTableView.addSubview(refresher)
        //        refresher.tintColor = UIColor.black
        refresher.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
    }
    
    func estimateRow() {
        cardTableView.estimatedRowHeight = 200.0
        cardTableView.rowHeight = UITableViewAutomaticDimension
        cardTableView.tableFooterView = UIView()
    }
    
    func addLogoToNavigationBar(logo: String)  {
        let logo = UIImage(named: logo)
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadTable()
    }
    
    func sortCard(_ sort: sortOperation) {
        switch sort {
        case .sortFromAtoZ :
            cards.sort() {  $0.name.lowercased() < $1.name.lowercased() }
            cardTableView.reloadData()
        case .sortFromZtoA:
            cards.sort() {  $0.name.lowercased() > $1.name.lowercased() }
            cardTableView.reloadData()
        case .dateUp:
            cards.sort() { $0.date < $1.date }
            cardTableView.reloadData()
        case .dateDown:
            cards.sort() { $0.date > $1.date }
            cardTableView.reloadData()
            
            
        }
    }
    func  filterColor(_ filter: tagColor) {
        switch filter {
        case .yellow:
            filterColorWithCoreData("0")
            cardTableView.reloadData()
        case .blue:
            filterColorWithCoreData("1")
            cardTableView.reloadData()
        case .red:
            filterColorWithCoreData("2")
            cardTableView.reloadData()
        case .brown:
            filterColorWithCoreData("3")
            cardTableView.reloadData()
        case .white:
            filterColorWithCoreData("4")
            cardTableView.reloadData()
        }
    }
    
    func filterColorWithCoreData(_ filter: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        fetchRequest.predicate = NSPredicate(format: "colorFilter == %@", filter)
        cards = try! context.fetch(fetchRequest) as! [Card]
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return .none
    }
}

extension CardListViewController: UITableViewDataSource, UITableViewDelegate, CardCellSubclassDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return searchResult.count
        } else {
            return cards.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier.cardListCell, for: indexPath)
            as! CardTableViewCell
        cell.delegate = self
        let card = (searchController.isActive) ? searchResult[indexPath.row] : cards[indexPath.row]
        
        cell.nameCard.text = card.name
        cell.frontImage.image = manager.loadImageFromPath(imgName: card.frontImage)
        let dateformat = DateFormatter()
        dateformat.dateStyle = .medium
        cell.date.text = dateformat.string(from: card.date)
        //        cell.date.text = card.date ? dateformat.string(from: cardArray.date) : ""
        cell.cardDescription.text = card.cardDescription
        
        if card.cardDescription == ""{
            cell.detailButton.isHidden = true
        } else {
            cell.detailButton.isHidden = false
        }
        cell.isExpanded = false
        
        switch card.colorFilter {
        case "0":
            cell.colorTag.backgroundColor = #colorLiteral(red: 1, green: 0.9902437188, blue: 0.3926091776, alpha: 1)
        case "1":
            cell.colorTag.backgroundColor = #colorLiteral(red: 0.3153670933, green: 0.6579984318, blue: 0.9986215793, alpha: 1)
        case "2":
            cell.colorTag.backgroundColor = #colorLiteral(red: 1, green: 0.484820628, blue: 0.3732572455, alpha: 1)
        case "3":
            cell.colorTag.backgroundColor = #colorLiteral(red: 0.8885628173, green: 0.6106459762, blue: 0.08318695495, alpha: 1)
        case "4":
            cell.colorTag.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        default:
            break
        }
        
        return cell
    }
    
    func buttonTapped(cell: CardTableViewCell) {
        guard let indexPath = self.cardTableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
        cell.isExpanded = !cell.isExpanded
        //        self.cardTableView.reloadRows(at: [indexPath], with: .fade)
        self.cardTableView.beginUpdates()
        self.cardTableView.endUpdates()
        
        
        print("Button tapped on row \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { action, index in
            print("edit button tapped")
            
            // move segue name to constants
            self.performSegue(withIdentifier: "editCardSegue", sender: self.cards[indexPath.row])
            
        }
        editAction.backgroundColor = UIColor.lightGray
        
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { action, index in
            print("share button tapped")
            
            let selectedFile = self.cards[indexPath.row].frontImage
            let selectedName = self.cards[indexPath.row].name
            //            self.sendEmail(attachment: selectedFile, title: selectedName)
            //            self.sendMessage(attachment: selectedFile, title: selectedName)
            
            let alert = UIAlertController(title: "Action Share", message: "Please enter ......", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Mail", style: UIAlertActionStyle.default){
                UIAlertAction in
                self.sendEmail(attachment: selectedFile, title: selectedName)
            })
            alert.addAction(UIAlertAction(title: "iMessage", style: UIAlertActionStyle.default){
                UIAlertAction in
                self.sendMessage(attachment: selectedFile, title: selectedName)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            print("delete button tapped")
            
            self.manager.delete(card: self.cards[indexPath.row])
            
            //            self.cards = self.manager.fetch()
            self.reloadTable()
            
        }
        
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, shareAction, editAction]
    }
    
    @objc private func reloadTable(){
        self.cards = self.manager.fetch()
        self.cardTableView.reloadData()
        refresher.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // constants segue
        if segue.identifier == "detailViewSegue"{
            let detailVC = segue.destination as! DetailViewController
            let indexpath = self.cardTableView.indexPathForSelectedRow
            let row = indexpath?.row
            //            detailVC.cardsDetail = cards[row!]
            
            if cards[row!].barcode.isEmpty{
                detailVC.imageCardsArray = [cards[row!].frontImage,cards[row!].backImage]
                print("Array count =\(detailVC.imageCardsArray.count)")
            } else {
                detailVC.imageCardsArray = [cards[row!].frontImage,cards[row!].backImage,cards[row!].barcodeImage ]
                print("Array count =\(detailVC.imageCardsArray.count)")
            }
        } else if segue.identifier == "editCardSegue" {
            
            let viewController = segue.destination as! AddCardVC
            viewController.logo = "edit"
            viewController.card = sender as? Card
            
            
        } else if segue.identifier == "popoverSegue"{
            let popoverViewController = segue.destination as! PopOverViewController
            popoverViewController.delegate = self
            popoverViewController.popoverPresentationController?.delegate = self
        }
    }
    
    
    @IBAction func unwindToCardList(segue: UIStoryboardSegue){
        //        dismiss(animated: true, completion: nil)
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            cardTableView.reloadData()
        }
    }
    
    func filterContent(searchText: String) {
        searchResult = cards.filter({(cards: Card)-> Bool in
            let nameCard = cards.name.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            
            return nameCard != nil
        })
    }
    
}

extension CardListViewController: MFMailComposeViewControllerDelegate{
    
    func sendEmail(attachment: String, title: String) {
        
        // Check if the device is capable to send email
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let emailTitle = "Sent My Card"
        let messageBody = "My card - \(title)"
        let toRecipients = ["yvients@gmail.com"]
        
        // Initialize the mail composer and populate the mail content
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        // Determine the file name and extension
        let fileparts = attachment.components(separatedBy: ".")
        let filename = fileparts[0]
        let fileExtension = fileparts[1]
        
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let imageURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(attachment))
        
        // Get the file data and MIME type
        if let fileData = try? Data(contentsOf: imageURL),
            let mimeType = MIMEType(type: fileExtension) {
            
            // Add attachment
            mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue,fileName: filename)
            
            // Present mail view controller on screen
            present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Failed to send: \(String(describing: error))")
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CardListViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch(result) {
        case MessageComposeResult.cancelled:
            print("SMS cancelled")
        case MessageComposeResult.failed:
            let alertMessage = UIAlertController(title: "Failure", message: "Failed to sent the message", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            
        case MessageComposeResult.sent:
            print("SMS sent")
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func sendMessage(attachment: String, title: String) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        // Prefill the SMS
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let imageURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(attachment))
        
        messageController.addAttachmentURL(imageURL, withAlternateFilename: nil)
        
        messageController.recipients = ["+380", "Name"]
        messageController.body = "Card Name - \(title)"
        
        present(messageController, animated: true, completion: nil)
        
    }
    
}

