import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class HomeViewController: UIViewController {
    
    
    
    let testHeight = 450
    let islandRef = Storage.storage().reference().child("posts")
    var posts = [Posts]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
        DispatchQueue.main.async {
            _ = UIView(frame: .zero)
        }        
        
    }
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["caption"] as! String
                let photoUrlString = dict["photoUrl"] as! String
                let profileImageUrl = dict["profileImageUrl"] as! String
                let userName = dict["userName"] as! String
                let post = Posts(captionText: captionText, photoUrlString: photoUrlString, userName: userName, profileImageUrl: profileImageUrl)
                self.posts.append(post)
                print(self.posts)
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
        print("go")
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
        let cell = Bundle.main.loadNibNamed("PostViewCell", owner: self, options: nil)?.first as! PostViewCell
        let post = posts[indexPath.row]
        let postUrl = URL(string: post.photoUrl!)
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: postUrl!)
                DispatchQueue.main.sync {
                    cell.postImageView.image = UIImage(data: data)
                }
            } catch {
            }}
        let profileImgUrl = URL(string: post.profileImage!)
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: profileImgUrl!)
                DispatchQueue.main.sync {
                    cell.userImage.image = UIImage(data: data)
                }
            } catch {
            }}
        
        cell.userName.text = posts[indexPath.row].user
        cell.captionLabel.text = "\(posts[indexPath.row].user!): \(posts[indexPath.row].caption)"
        return cell
    }
}

// работающая версия отображения ячейки c URLфото
//extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return  posts.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
//        let post = posts[indexPath.row]
//        cell.textLabel?.text = posts[indexPath.row].caption
//
//        let url = URL(string: post.photoUrl!)
//        DispatchQueue.global().async {
//            do{
//                let data = try Data(contentsOf: url!)
//                DispatchQueue.main.sync {
//                    cell.imageView!.image = UIImage(data: data)
//                }
//            } catch {
//            }}
//        return cell
//    }
//}



