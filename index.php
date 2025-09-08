<?php
session_start();
require_once 'config/database.php';
require_once 'app/Recipe.php';
require_once 'app/User.php';

$action = $_GET['action'] ?? 'home';
$recipe = new Recipe();
$user = new User();

// Check if user is logged in for protected actions
$protectedActions = ['create', 'edit', 'delete', 'toggle_favorite', 'favorites', 'admin'];
if (in_array($action, $protectedActions) && !isset($_SESSION['user_id'])) {
    $_SESSION['error'] = 'Please login to access this feature.';
    header('Location: index.php?action=login');
    exit;
}

// Check admin access
if ($action === 'admin' && (!isset($_SESSION['user_id']) || !$_SESSION['is_admin'])) {
    $_SESSION['error'] = 'Access denied. Admin privileges required.';
    header('Location: index.php');
    exit;
}

// Handle different actions
switch ($action) {
    case 'login':
        if ($_POST) {
            $loginUser = $user->login($_POST['username'], $_POST['password']);
            if ($loginUser) {
                $_SESSION['user_id'] = $loginUser['id'];
                $_SESSION['username'] = $loginUser['username'];
                $_SESSION['full_name'] = $loginUser['full_name'];
                $_SESSION['is_admin'] = $loginUser['is_admin'];
                $_SESSION['success'] = 'Welcome back, ' . $loginUser['full_name'] . '!';
                header('Location: index.php');
                exit;
            } else {
                $_SESSION['error'] = 'Invalid username or password.';
            }
        }
        include 'views/login.php';
        break;
        
    case 'register':
        if ($_POST) {
            if ($_POST['password'] !== $_POST['confirm_password']) {
                $_SESSION['error'] = 'Passwords do not match.';
            } elseif (strlen($_POST['password']) < 6) {
                $_SESSION['error'] = 'Password must be at least 6 characters long.';
            } else {
                $result = $user->register($_POST['username'], $_POST['email'], $_POST['password'], $_POST['full_name']);
                if ($result) {
                    $_SESSION['success'] = 'Registration successful! Please login.';
                    header('Location: index.php?action=login');
                    exit;
                } else {
                    $_SESSION['error'] = 'Username or email already exists.';
                }
            }
        }
        include 'views/register.php';
        break;
        
    case 'logout':
        session_destroy();
        header('Location: index.php');
        exit;
        break;
    case 'home':
        $current_user_id = $_SESSION['user_id'] ?? null;
        $recipes = $recipe->getAll($current_user_id);
        $randomRecipe = $recipe->getRandomRecipe();
        include 'views/home.php';
        break;
    
    case 'create':
        if ($_POST) {
            // Parse ingredient amounts for detailed calorie calculation
            $ingredientsData = [];
            if (isset($_POST['ingredient_amounts'])) {
                $ingredients = json_decode($_POST['ingredient_amounts'], true);
                if ($ingredients) {
                    $calculatedCalories = $recipe->calculateDetailedCalories($ingredients);
                } else {
                    $calculatedCalories = $_POST['calories'] ?? 0;
                }
            } else {
                $calculatedCalories = $_POST['calories'] ?? 0;
            }
            
            $data = [
                'title' => $_POST['title'],
                'ingredients' => $_POST['ingredients'],
                'steps' => $_POST['steps'],
                'category' => $_POST['category'],
                'image' => $_POST['image'] ?? '',
                'calories' => $calculatedCalories,
                'user_id' => $_SESSION['user_id']
            ];
            if ($recipe->create($data)) {
                $_SESSION['success'] = 'Recipe created successfully!';
                header('Location: index.php');
                exit;
            }
        }
        include 'views/create.php';
        break;
    
    case 'view':
        $id = $_GET['id'] ?? 0;
        $current_user_id = $_SESSION['user_id'] ?? null;
        $recipeData = $recipe->getById($id, $current_user_id);
        include 'views/view.php';
        break;
    
    case 'edit':
        $id = $_GET['id'] ?? 0;
        $current_user_id = $_SESSION['user_id'];
        $recipeData = $recipe->getById($id, $current_user_id);
        
        if (!$recipe->canEditRecipe($id, $current_user_id)) {
            $_SESSION['error'] = 'You can only edit your own recipes.';
            header('Location: index.php?action=view&id=' . $id);
            exit;
        }
        
        if ($_POST) {
            $calculatedCalories = $_POST['calories'] ?? 0;
            if (isset($_POST['ingredient_amounts'])) {
                $ingredients = json_decode($_POST['ingredient_amounts'], true);
                if ($ingredients) {
                    $calculatedCalories = $recipe->calculateDetailedCalories($ingredients);
                }
            }
            
            $data = [
                'title' => $_POST['title'],
                'ingredients' => $_POST['ingredients'],
                'steps' => $_POST['steps'],
                'category' => $_POST['category'],
                'image' => $_POST['image'] ?? '',
                'calories' => $calculatedCalories
            ];
            if ($recipe->update($id, $data, $current_user_id)) {
                $_SESSION['success'] = 'Recipe updated successfully!';
                header('Location: index.php?action=view&id=' . $id);
                exit;
            }
        }
        include 'views/edit.php';
        break;
    
    case 'delete':
        $id = $_GET['id'] ?? 0;
        $current_user_id = $_SESSION['user_id'];
        if ($recipe->delete($id, $current_user_id)) {
            $_SESSION['success'] = 'Recipe deleted successfully!';
        } else {
            $_SESSION['error'] = 'You can only delete your own recipes.';
        }
        header('Location: index.php');
        exit;
        break;
    
    case 'favorites':
        $current_user_id = $_SESSION['user_id'];
        $favorites = $recipe->getFavorites($current_user_id);
        include 'views/favorites.php';
        break;
    
    case 'toggle_favorite':
        $id = $_GET['id'] ?? 0;
        $current_user_id = $_SESSION['user_id'];
        $recipe->toggleFavorite($current_user_id, $id);
        header('Location: ' . ($_SERVER['HTTP_REFERER'] ?? 'index.php'));
        exit;
        break;
    
    case 'search':
        $query = $_GET['q'] ?? '';
        $category = $_GET['category'] ?? '';
        $current_user_id = $_SESSION['user_id'] ?? null;
        $recipes = $recipe->search($query, $category, $current_user_id);
        include 'views/search.php';
        break;
    
    case 'admin':
        // Admin panel - get all data for dashboard
        $allUsers = $user->getAllUsers();
        $allRecipes = $recipe->getAll();
        $categories = $recipe->getCategories();
        
        // Calculate total favorites
        $favoritesSql = "SELECT COUNT(*) FROM user_favorites";
        $favoritesStmt = $pdo->query($favoritesSql);
        $totalFavorites = $favoritesStmt->fetchColumn();
        
        include 'views/admin.php';
        break;
    
    case 'admin_delete_user':
        if ($_SESSION['is_admin']) {
            $userId = $_GET['id'] ?? 0;
            if ($user->deleteUser($userId)) {
                $_SESSION['success'] = 'User deleted successfully.';
            } else {
                $_SESSION['error'] = 'Cannot delete admin users.';
            }
        }
        header('Location: index.php?action=admin');
        exit;
        break;
    
    case 'profile':
        $current_user_id = $_SESSION['user_id'];
        $userData = $user->getUserById($current_user_id);
        $userRecipes = $recipe->getUserRecipes($current_user_id);
        include 'views/profile.php';
        break;
        
    case 'update_profile':
        if ($_POST) {
            $current_user_id = $_SESSION['user_id'];
            if ($user->updateProfile($current_user_id, $_POST['full_name'], $_POST['email'])) {
                $_SESSION['full_name'] = $_POST['full_name'];
                $_SESSION['success'] = 'Profile updated successfully!';
            } else {
                $_SESSION['error'] = 'Failed to update profile.';
            }
        }
        header('Location: index.php?action=profile');
        exit;
        break;
    
    default:
        header('Location: index.php');
        exit;
}
?>