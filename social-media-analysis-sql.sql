CREATE DATABASE social_media_analysis;
USE social_media_analysis;

-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    join_date DATE
);

-- Posts table
CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    content VARCHAR(255),
    post_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Likes table
CREATE TABLE likes (
    like_id INT PRIMARY KEY,
    user_id INT,
    post_id INT,
    like_date DATETIME
);

-- Comments table
CREATE TABLE comments (
    comment_id INT PRIMARY KEY,
    user_id INT,
    post_id INT,
    comment_text VARCHAR(255),
    comment_date DATETIME
);

INSERT INTO users VALUES
(1, 'Alice', '2025-01-01'),
(2, 'Bob', '2025-02-01'),
(3, 'Charlie', '2025-03-01');

INSERT INTO posts VALUES
(1, 1, 'Hello World!', '2026-04-01 10:00:00'),
(2, 2, 'My first post', '2026-04-02 11:00:00'),
(3, 1, 'Learning SQL', '2026-04-03 12:00:00');

INSERT INTO likes VALUES
(1, 2, 1, '2026-04-01 10:05:00'),
(2, 3, 1, '2026-04-01 10:10:00'),
(3, 1, 2, '2026-04-02 11:10:00');

INSERT INTO comments VALUES
(1, 2, 1, 'Nice post!', '2026-04-01 10:06:00'),
(2, 3, 1, 'Great!', '2026-04-01 10:07:00'),
(3, 1, 2, 'Thanks!', '2026-04-02 11:15:00');


SELECT u.username, COUNT(p.post_id) AS total_posts
FROM users u
JOIN posts p ON u.user_id = p.user_id
GROUP BY u.username
ORDER BY total_posts DESC;

-- liked post:
SELECT p.post_id, p.content, COUNT(l.like_id) AS total_likes
FROM posts p
LEFT JOIN likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content
ORDER BY total_likes DESC;
-- comment post
SELECT p.post_id, p.content, COUNT(c.comment_id) AS total_comments
FROM posts p
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content
ORDER BY total_comments DESC;


-- user Engagement (Likes + Comments)
SELECT u.username,
       COUNT(DISTINCT l.like_id) AS total_likes,
       COUNT(DISTINCT c.comment_id) AS total_comments
FROM users u
LEFT JOIN likes l ON u.user_id = l.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
GROUP BY u.username;


-- Trending Posts (Advanced)
SELECT p.post_id, p.content,
       COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id) AS engagement
FROM posts p
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content
ORDER BY engagement DESC;


-- Window Function (Ranking Posts)
SELECT post_id, content, engagement,
       RANK() OVER (ORDER BY engagement DESC) AS rank_position
FROM (
    SELECT p.post_id, p.content,
           COUNT(l.like_id) AS engagement
    FROM posts p
    LEFT JOIN likes l ON p.post_id = l.post_id
    GROUP BY p.post_id, p.content
) t;

drop view if exists social_media_report;

-- Add Final View (Project Highlight)
CREATE VIEW social_media_report AS
SELECT p.post_id, p.content,
       COUNT(DISTINCT l.like_id) AS likes,
       COUNT(DISTINCT c.comment_id) AS comments,
       COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id) AS engagement
FROM posts p
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, p.content;