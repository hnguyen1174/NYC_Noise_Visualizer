import pandas as pd
import praw
import datetime

# Util Function
def get_date(submission):
    time = submission.created
    return datetime.datetime.fromtimestamp(time)

if __name__ == "__main__":
    
    reddit = praw.Reddit(client_id='egcd0UrpvCUR6g', 
                         client_secret='zzz4_4IpuBcYZ9v9LwepA8yFduvNqQ', 
                         user_agent='nyc_housing_scraper')

    posts = []
    ml_subreddit = reddit.subreddit('NYCapartments')
    for post in ml_subreddit.new(limit=1000):
        posts.append([post.title, post.score, post.id, post.url, post.num_comments, post.selftext, get_date(post)])
    posts = pd.DataFrame(posts,columns=['title', 'score', 'id', 'url', 'num_comments', 'body', 'created'])

    posts.to_csv('reddit_postings.csv')
    