import Foundation
import CoreData
import UIKit

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var context: NSManagedObjectContext?
    private var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    // MARK: - Properties

    func fetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        if _fetchedResultsController != nil {
            return _fetchedResultsController
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        guard let _fetchedResultsController = _fetchedResultsController else {
            print("Could not create fetchedResultsController")
            abort()
        }
        _fetchedResultsController.delegate = self

        do {
            try _fetchedResultsController.performFetch()
        } catch {
            print("Unresolved error 3 \(error)")
            abort()
        }

        return _fetchedResultsController
    }

    // MARK: - Interface Methods

    @IBAction func addButtonTapped(_ sender: Any) {
        if let context = context {
            _ = Person.insertWithRandomName(in: context)
        }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        do {
            try context?.save()
        } catch {
            print("Unresolved error 4 \(error)")
            abort()
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController()?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if self.fetchedResultsController()?.sections?.count ?? 0 > 0 {
            let sectionInfo: NSFetchedResultsSectionInfo? = self.fetchedResultsController()?.sections?[section]
            rows = sectionInfo?.numberOfObjects ?? 0
        }
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        configureCell(cell, at: indexPath)

        return cell
    }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let p = fetchedResultsController()?.object(at: indexPath) as? Person
        cell.textLabel?.text = p?.name
    }

    // MARK: - Fetched results controller delegate

    /* Compared to Zach Orr's original code, two implementations were removed
     and the following one changed, because Zach's raised exceptions when
     adding or removing Person objects after building with Swift 5 and running
     in iOS 12.  The implementation which remains is sufficient to enable
     change tracking in the fetched results controller, which I think does all
     of the work Zach's code was trying to do here.  Anyhow, it works now :) */

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
