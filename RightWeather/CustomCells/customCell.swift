

import UIKit

class customCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var imgOfReport: UIImageView!
    
    @IBOutlet weak var lbldesc: UILabel!
    
    @IBOutlet weak var lbltemp: UILabel!
    
    @IBOutlet weak var lblClouds: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnBackOnClick(_ sender: Any) {
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class newAlertCell: UITableViewCell {
    
    
    @IBOutlet weak var lblnewTitle: UILabel!
    
    @IBOutlet weak var lblnewsDes: UILabel!
    
    @IBOutlet weak var lbltime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnBackOnClick(_ sender: Any) {
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

