-- Enhanced Recipe Manager Database Setup with Authentication
-- Run this SQL script in phpMyAdmin or MySQL command line

-- Create database
CREATE DATABASE IF NOT EXISTS recipe_manager;
USE recipe_manager;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create recipes table with user ownership
CREATE TABLE IF NOT EXISTS recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    ingredients TEXT NOT NULL,
    steps TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    image VARCHAR(255),
    calories INT DEFAULT 0,
    user_id INT NOT NULL,
    favorites_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Update existing recipes table if it doesn't have the new columns
ALTER TABLE recipes 
ADD COLUMN IF NOT EXISTS user_id INT NOT NULL DEFAULT 2,
ADD COLUMN IF NOT EXISTS favorites_count INT DEFAULT 0;

-- Add foreign key constraint (ignore error if it already exists)
SET @sql = IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
              WHERE CONSTRAINT_NAME = 'fk_recipes_user_id' 
              AND TABLE_NAME = 'recipes' 
              AND TABLE_SCHEMA = DATABASE()) = 0,
              'ALTER TABLE recipes ADD CONSTRAINT fk_recipes_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE',
              'SELECT "Foreign key already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Remove old is_favorite column if it exists
ALTER TABLE recipes DROP COLUMN IF EXISTS is_favorite;

-- Create user_favorites table for many-to-many relationship
CREATE TABLE IF NOT EXISTS user_favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipe_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_favorite (user_id, recipe_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
);

-- Create daily_recipe table for Recipe of the Day persistence
CREATE TABLE IF NOT EXISTS daily_recipe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    date DATE NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
);

-- Create ingredient_amounts table for detailed calorie calculation
CREATE TABLE IF NOT EXISTS ingredient_amounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    ingredient_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    calories_per_unit DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
);

-- Insert default admin user (password: admin123)
INSERT IGNORE INTO users (username, email, password, full_name, is_admin) VALUES 
('admin', 'admin@recipemanager.com', '$2y$10$UODv5jZU6fwuEO2PY8/cVObqb8Efi0tW8Bka4FQZu.SdO251IbqTm', 'System Administrator', TRUE);

-- Insert sample regular user (password: user123)
INSERT IGNORE INTO users (username, email, password, full_name, is_admin) VALUES 
('chef_maria', 'maria@example.com', '$2y$10$uFI08tfDA5dHlNjr9KNYw.894me87AYeLDhzv2akdh9n2OcsZAE72', 'Maria Rodriguez', FALSE);

-- Insert sample recipes with user ownership
INSERT INTO recipes (title, ingredients, steps, category, image, calories, user_id, favorites_count) VALUES 
(
    'Classic Spaghetti Carbonara',
    '400g spaghetti\n200g pancetta or bacon\n4 large eggs\n100g Pecorino Romano cheese\n2 cloves garlic\nBlack pepper\nSalt\nOlive oil',
    '1. Cook spaghetti in boiling salted water until al dente\n2. Meanwhile, heat olive oil in a large pan and cook pancetta until crispy\n3. Beat eggs with grated cheese and black pepper\n4. Drain pasta and add to the pan with pancetta\n5. Remove from heat and quickly mix in egg mixture\n6. Toss until creamy, adding pasta water if needed\n7. Serve immediately with extra cheese',
    'Main Course',
    'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800&h=600&fit=crop',
    750,
    2,
    15
),
(
    'Chocolate Chip Cookies',
    '2¼ cups flour\n1 tsp baking soda\n1 tsp salt\n1 cup butter\n¾ cup granulated sugar\n¾ cup brown sugar\n2 eggs\n2 tsp vanilla\n2 cups chocolate chips',
    '1. Preheat oven to 375°F (190°C)\n2. Mix flour, baking soda, and salt\n3. Cream butter and sugars until fluffy\n4. Beat in eggs and vanilla\n5. Gradually add flour mixture\n6. Stir in chocolate chips\n7. Drop spoonfuls on baking sheet\n8. Bake 9-11 minutes until golden\n9. Cool on wire rack',
    'Dessert',
    'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=800&h=600&fit=crop',
    180,
    2,
    8
),
(
    'Fresh Caesar Salad',
    'Romaine lettuce\nParmesan cheese\nCroutons\n2 cloves garlic\n2 anchovies\n1 egg yolk\nLemon juice\nOlive oil\nWorcestershire sauce\nDijon mustard\nBlack pepper',
    '1. Wash and chop romaine lettuce\n2. Make dressing: mash garlic and anchovies\n3. Whisk in egg yolk, lemon juice, and mustard\n4. Slowly drizzle in olive oil while whisking\n5. Add Worcestershire and pepper\n6. Toss lettuce with dressing\n7. Top with Parmesan and croutons\n8. Serve immediately',
    'Appetizer',
    'https://images.unsplash.com/photo-1551248429-40975aa4de74?w=800&h=600&fit=crop',
    320,
    2,
    12
);

-- Insert sample ingredient amounts for detailed calorie calculation
INSERT INTO ingredient_amounts (recipe_id, ingredient_name, amount, unit, calories_per_unit) VALUES
(1, 'spaghetti', 400, 'g', 1.31),
(1, 'pancetta', 200, 'g', 5.41),
(1, 'eggs', 4, 'piece', 70),
(1, 'cheese', 100, 'g', 4.31),
(2, 'flour', 270, 'g', 3.64),
(2, 'butter', 225, 'g', 7.17),
(2, 'chocolate chips', 340, 'g', 4.79),
(3, 'lettuce', 200, 'g', 0.15),
(3, 'cheese', 50, 'g', 4.31),
(3, 'olive oil', 30, 'ml', 8.84);

-- Sample favorites
INSERT INTO user_favorites (user_id, recipe_id) VALUES
(2, 1),
(2, 3);

-- Display success message
SELECT 'Enhanced database setup completed successfully!' as message;