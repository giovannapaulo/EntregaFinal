const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/AuthController');

router.post('/registrar', AuthController.registrar);
router.post('/logar', AuthController.logar);

module.exports = router;