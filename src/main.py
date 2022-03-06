import os
import pandas as pd
from instagramy import InstagramUser
from collections import defaultdict
from datetime import datetime
from google.cloud import storage


def main():
    print("starting function")
    result = log_data()
    print("end function / result :", result)
    # Changement manuel du sessionid pour l'instant
    session_id = "51744929721%3ARmvyDanBisbGGN%3A2"
    instagram_target_username = 'selenagomez'
    # print("before scraping command")
    # os.system(f"instagram-scraper {instagram_target_username} -u instapoc25 -p Azertyuiop1 "
    #           f"--cookiejar cookie.jar -m 20 -")
    # print("end function")
    # """
    headers = {"login_username":"instapoc25", "login_password":"Azertyuiop1"}
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
    infos_csv = infos_df.to_csv()
    print("middle function")
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
    posts_csv = posts_df.to_csv()

    # upload_blob('reda-bucket-tf', infos_csv, f'{instagram_target_username}-infos.csv')
    # upload_blob('reda-bucket-tf', posts_csv, f'{instagram_target_username}-posts.csv')
    print("infos and posts sent to buckets")


def upload_blob(bucket_name, blob_text, destination_blob_name):
    """Uploads a file to the bucket."""
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_string(blob_text)

    print('File uploaded to {}.'.format(destination_blob_name))


def log_data():
    BUCKET_NAME = 'reda-bucket-tf'
    BLOB_NAME = 'test-blob'
    BLOB_STR = '{"blob": "some json"}'

    upload_blob(BUCKET_NAME, BLOB_STR, BLOB_NAME)
    return f'Success!'


if __name__ == "__main__":
    main()
