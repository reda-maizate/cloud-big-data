import os
import pandas as pd
from instagramy import InstagramUser, InstagramPost
from collections import defaultdict
from datetime import date, datetime


def main():
    BUCKET = 'reda-project'
    os.environ['BUCKET'] = 'reda-project'

    # Changement manuel du sessionid pour l'instant
    session_id = "51744929721%3ARmvyDanBisbGGN%3A2"
    instagram_target_username = 'selenagomez'

    user = InstagramUser(instagram_target_username, sessionid=session_id)

    # Récupération informations sur le compte
    infos_dict = defaultdict(list)

    infos_dict["username"].append(user.username)
    infos_dict["biography"].append(user.biography)
    infos_dict["number_of_followers"].append(user.number_of_followers)
    infos_dict["number_of_followings"].append(user.number_of_followings)
    infos_dict["number_of_posts"].append(user.number_of_posts)
    infos_dict["is_verified"].append(user.is_verified)

    infos_df = pd.DataFrame(infos_dict)
    infos_df.to_csv(f"{instagram_target_username}-infos.csv", index=False)

    # Créer un dataframe contenant tout ses posts dans un dataframe
    posts_dict = defaultdict(list)
    posts = user.posts

    for post in posts:
        # Ajouter à une list de numpy array, chacun des attributs dont on a besoin
        posts_dict["post_url"].append(post.post_url)
        posts_dict["likes"].append(post.likes)
        posts_dict["comments"].append(post.comments)
        posts_dict["is_video"].append(post.is_video)
        posts_dict["caption"].append(post.caption)
        posts_dict["location"].append(post.location)
        posts_dict["post_source"].append(post.post_source)
        posts_dict["timestamp"].append(datetime.fromtimestamp(post.timestamp))
        posts_dict["shortcode"].append(post.shortcode)

    posts_df = pd.DataFrame(posts_dict)
    posts_df.to_csv(f"{instagram_target_username}-posts.csv", index=False)

    # bashCommand = "gsutil cp *.csv gs://$BUCKET/"
    # process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
    # output, error = process.communicate()


if __name__ == "__main__":
    main()
