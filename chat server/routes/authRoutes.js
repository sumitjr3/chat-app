import { Router } from 'express';
import { signup, login } from '../controllers/authController.js'; 
import User from '../models/user.js';

const router = Router();

// POST /signup
router.post('/signup', signup);

// POST /login
router.post('/login', login);


export default router;
