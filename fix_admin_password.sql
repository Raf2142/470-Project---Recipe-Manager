-- Fix Admin Password - Run this in phpMyAdmin to update existing passwords
USE recipe_manager;

-- Update admin password (password: admin123)
UPDATE users SET password = '$2y$10$UODv5jZU6fwuEO2PY8/cVObqb8Efi0tW8Bka4FQZu.SdO251IbqTm' WHERE username = 'admin';

-- Update regular user password (password: user123)
UPDATE users SET password = '$2y$10$uFI08tfDA5dHlNjr9KNYw.894me87AYeLDhzv2akdh9n2OcsZAE72' WHERE username = 'chef_maria';

-- Display updated users
SELECT username, full_name, is_admin, 'Password updated successfully' as status FROM users WHERE username IN ('admin', 'chef_maria');