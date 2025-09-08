# Recipe Manager

> A comprehensive web-based recipe management system with user authentication, admin panel, and advanced features.

[![PHP](https://img.shields.io/badge/PHP-7.4+-777BB4?style=flat-square&logo=php&logoColor=white)](https://php.net)
[![MySQL](https://img.shields.io/badge/MySQL-5.7+-4479A1?style=flat-square&logo=mysql&logoColor=white)](https://mysql.com)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.0+-7952B3?style=flat-square&logo=bootstrap&logoColor=white)](https://getbootstrap.com)

## ✨ Features

### 🔐 User Authentication
- User registration and login
- Secure password hashing with PHP
- Session management
- User profile management

### 👨‍💼 Admin Panel
- Admin dashboard with statistics
- User management capabilities
- Recipe oversight and moderation
- System administration tools

### 📖 Recipe Management
- Full CRUD operations for recipes
- Recipe ownership and permissions
- Rich recipe details (ingredients, instructions, calories)
- Recipe categorization

### 🔍 Advanced Search
- Search by recipe name or ingredients
- Filter by categories
- User-specific favorites integration
- Real-time search results

### ❤️ Favorites System
- Personal favorites for each user
- Favorite count display
- Easy toggle functionality
- Dedicated favorites page

### 🧮 Calorie Calculator
- Automatic calorie calculation from ingredients
- Multiple unit support (grams, kg, cups, pieces)
- Comprehensive ingredient database
- Detailed nutritional breakdown

### 🍳 Daily Recipe
- "Recipe of the Day" feature
- 24-hour persistence
- Automatic daily rotation

## 🛠️ Tech Stack

- **Frontend**: HTML5, CSS3, Bootstrap 5, JavaScript
- **Backend**: PHP 7.4+
- **Database**: MySQL 5.7+
- **Web Server**: Apache
- **Development**: XAMPP (recommended)

## 🚀 Installation

### Prerequisites

- PHP 7.4 or higher
- MySQL 5.7 or higher
- Apache web server
- [XAMPP](https://www.apachefriends.org/) (recommended for local development)

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/recipe-manager.git
   cd recipe-manager
   ```

2. **Set up the web server**
   - For XAMPP: Copy the project to `htdocs/recipe-manager/`
   - For other setups: Configure your web server to serve the project directory

3. **Database setup**
   ```bash
   # Access phpMyAdmin at http://localhost/phpmyadmin
   # Import the database_setup_enhanced.sql file
   ```
   
   Or run the SQL commands manually:
   ```sql
   -- Import database_setup_enhanced.sql or database_setup.sql
   ```

4. **Configure database connection**
   - Update `config/database.php` with your database credentials if needed
   - Default settings work with standard XAMPP installation

5. **Start the application**
   ```bash
   # Start Apache and MySQL services
   # Visit http://localhost/recipe-manager
   ```

### Default Accounts

| Role | Username | Password | Description |
|------|----------|----------|--------------|
| Admin | `admin` | `admin123` | Full system access |
| User | `chef_maria` | `user123` | Sample user account |

## 📖 Usage

### Getting Started

1. **Create an Account**: Register with username, email, and password
2. **Login**: Access your personalized dashboard
3. **Explore**: Browse recipes, use search and filters
4. **Create**: Add your own recipes with detailed information
5. **Manage**: Edit your recipes and build your favorites collection

### Key Features

- **Recipe Management**: Create, edit, and delete your recipes
- **Search & Filter**: Find recipes by name, ingredients, or category
- **Favorites**: Save and organize your favorite recipes
- **Calorie Calculator**: Get nutritional information automatically
- **Daily Recipe**: Discover new recipes with the daily featured recipe
- **Admin Tools**: Comprehensive admin panel for user and recipe management

## 📁 Project Structure

```
recipe-manager/
├── index.php                 # Main application router
├── composer.json            # PHP dependencies
├── database_setup.sql       # Basic database schema
├── database_setup_enhanced.sql # Enhanced schema with sample data
├── config/
│   └── database.php         # Database configuration
├── app/
│   ├── Recipe.php          # Recipe model and CRUD operations
│   └── User.php            # User model and authentication
└── views/
    ├── layout.php          # Main layout template
    ├── home.php           # Homepage with recipe grid
    ├── login.php          # User authentication
    ├── register.php       # User registration
    ├── profile.php        # User profile management
    ├── admin.php          # Admin dashboard
    ├── create.php         # Recipe creation form
    ├── edit.php           # Recipe editing form
    ├── view.php           # Recipe detail view
    ├── favorites.php      # User favorites
    └── search.php         # Search and filter results
```

## 🏗️ Architecture

- **MVC Pattern**: Clean separation of concerns
- **Responsive Design**: Mobile-first with Bootstrap 5
- **Security**: Prepared statements and input validation
- **Session Management**: Secure user authentication
- **Database**: Normalized MySQL schema with relationships

## 🔧 Configuration

### Database Settings

Update `config/database.php` with your database credentials:

```php
<?php
$host = 'localhost';
$dbname = 'recipe_manager';
$username = 'your_username';
$password = 'your_password';
?>
```

### Customization

- **Categories**: Edit category options in relevant view files
- **Styling**: Modify Bootstrap classes or add custom CSS in `views/layout.php`
- **Calorie Database**: Extend the ingredient calorie map in the calorie calculator

## 🐛 Troubleshooting

### Common Issues

- **Database Connection**: Ensure MySQL is running and credentials are correct
- **File Permissions**: Check web server has read access to project files
- **Missing Database**: Import the SQL file to create required tables

### Debug Mode

Enable PHP error reporting for development:
```php
ini_set('display_errors', 1);
error_reporting(E_ALL);
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -am 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🚀 Future Enhancements

- [ ] Image upload for recipes
- [ ] Recipe ratings and reviews
- [ ] Social sharing features
- [ ] Mobile app development
- [ ] API development
- [ ] Advanced meal planning
- [ ] Shopping list generation
- [ ] Nutritional API integration

---

**Happy cooking! 🍳👨‍🍳**