//
//  NSReceiptVC.swift
//  Cashier
//
//  Created by Saikiran.
//  Copyright © 2016 Sample. All rights reserved.
//

import UIKit

class NSReceiptVC: NSBaseVC , UICollectionViewDataSource, UICollectionViewDelegate{
	@IBOutlet var headerlabel1: UILabel!
	@IBOutlet var headerLabel2: UILabel!
	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var headerLabel3: UILabel!

	@IBOutlet var cvbgview: UIView!
	let numberofItems : CGFloat = 3
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

		
		self.collectionView.setCollectionViewLayout(NSReceiptCollectionLayout(size: collectionView.frame.size), animated: true)
		
		setCollectionViewBgView()

		headerlabel1.text = "Select"
		headerLabel2.text = "Item"
		headerLabel3.text = "Quantity"

    }
	
	func setCollectionViewBgView()  {
		
		
		let view =  UIView(frame: self.collectionView.bounds)
		let spacing = ( self.collectionView.frame.width ) / numberofItems - 3/3
		
		for i in 0..<Int(numberofItems) {
			
			if i != Int(numberofItems)-1 {
				
				let height = view.frame.height + 100;
				
				let lb1 = UILabel(frame: CGRect(x: (spacing ) * CGFloat(i+1) ,y: 0, width: 1 ,height: height))
				lb1.backgroundColor = UIColor(colorLiteralRed: 104/255.0, green: 129/255.0, blue: 152/255.0, alpha: 1.0)
				
				view.addSubview(lb1)

			}

		}
		collectionView.backgroundView = view
		
		
		
	}
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 10
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Int(numberofItems) ;
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                           sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		
		let spacing = ( self.collectionView.frame.width ) / 3


		return CGSize (width: spacing, height: 30);
	}
	
	

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		var reusableview :UICollectionReusableView?
		
		if kind ==  UICollectionElementKindSectionHeader{
		
		let header = 	collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
			
			if let receiptsHeader = header as? NSReceiptsCVHeaderView {
			
				receiptsHeader.label1.text = "Select"
				receiptsHeader.label1.text = "Item"
				receiptsHeader.label1.text = "Quantity"
				
				reusableview = receiptsHeader
			}
		
		}
		return reusableview ?? UICollectionReusableView(frame: CGRect.zero)

	}
	
	

	/*
	- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
	{
	UICollectionReusableView *reusableview = nil;
	
	if (kind == UICollectionElementKindSectionHeader) {
	RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
	NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
	headerView.title.text = title;
	UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
	headerView.backgroundImage.image = headerImage;
	
	reusableview = headerView;
	}
 
	if (kind == UICollectionElementKindSectionFooter) {
	UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
	
	reusableview = footerview;
	}
	
	return reusableview;
	}
*/
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		
		var identifier = "cell"
		
			if indexPath.row == 0 {
				identifier = "checkmark"
			}
			else if indexPath.row == 1 {
				identifier = "cell"
			}
			else {
				identifier = "quantity"
			}
			
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

		
			if let customcell = cell as? NSCustomCell {
				
				if indexPath.section != 0 && customcell.label != nil {
				customcell.label.text = "selecfnjhhjjhjhjhhjghghgjhgjhgjgjgj"
				}
								
			}
		
		

		
		
		
		
		return cell
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	@IBAction func actionSubmitReceiptDetails(_ sender: AnyObject) {
	}
	
	@IBAction func actionPlus(_ sender: AnyObject) {
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
	
    */

}
