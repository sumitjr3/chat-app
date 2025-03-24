import { Router } from 'express';
import { findUser , getChatList } from '../controllers/userController.js';

const router = Router();

//get user api route
router.get('/find-particular-user', findUser);

//get chat list api route
router.get('/get-chat-list', getChatList);

export default router;


