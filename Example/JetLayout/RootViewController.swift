import UIKit
import JetLayout

class RootController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "JetLayout samples"
        
        _ = Table(tableView) {
            TSection(header: nil, footer: nil) {
                
                Text("Bindings sample")
                    .alignment(.fill(toPadding: true))
                    .cell()
                    .accessory(.disclosureIndicator)
                    .didSelect {
                        
                    }
                
                Text("Table with dynamic cells")
                    .alignment(.fill(toPadding: true))
                    .cell()
                    .selectionColor(UIColor.blue.withAlphaComponent(0.1))
                    .accessory(.disclosureIndicator)
                    .didSelect {
                        
                    }
                
                Text("Layout sample")
                    .alignment(.fill(toPadding: true))
                    .cell()
                    .selectionColor(UIColor.green.withAlphaComponent(0.1))
                    .accessory(.disclosureIndicator)
                    .didSelect {
                    
                    }
            }
        }
        
        let header = headerView.toUIView()
        header.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 90))
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
    }
    
    var headerView: View {
        VStack(spacing: 12) {
            Spacer()
            
            Text("Table with stactic section")
                .font(.headline)
                .textAlignment(.center)
            
            Text("Cells are attached to existing UITableViewController")
                .numberOfLines(0)
                .color(.systemGray)
                .font(.subheadline)
        }
        .preserveParentPadding()
    }
}

