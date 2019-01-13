import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Kingfisher


class HomeViewController: UIViewController {
    
    
    
    let testHeight = 450
    let islandRef = Storage.storage().reference().child("posts")
    var posts = [Posts]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        let nib = UINib(nibName: "PostViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomPostCell")
        //
        
        loadPosts()
        
        
    }
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["caption"] as! String
                let photoUrlString = dict["photoUrl"] as! String
                let profileImageUrl = dict["profileImageUrl"] as! String
                let userName = dict["userName"] as! String
                let post = Posts(captionText: captionText, photoUrlString: photoUrlString, userName: userName, profileImageUrl: profileImageUrl)
                self.posts.append(post)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInView")
            self.present(signInVC, animated: true, completion: nil)
        } catch let logoutError  {
            print (logoutError)
        }
    }
    
    
    @IBAction func massageButton(_ sender: Any) {
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(testHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: PostViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CustomPostCell")  as? PostViewCell else {
            fatalError()
        }
        
        let post = posts[indexPath.row]
        let postUrl = URL(string: post.photoUrl!)
        let userUrl = URL(string: post.profileImage!)
        
        cell.userImage.kf.setImage(with: userUrl)
        cell.postImageView.kf.setImage(with: postUrl)
        cell.userName.text = posts[indexPath.row].user
        cell.captionLabel.text = "\(posts[indexPath.row].user!): \(posts[indexPath.row].caption)"
        return cell
    }
}
