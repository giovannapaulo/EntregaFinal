const express = require('express');
const router = express.Router();
const RegistroSintomaController = require('../controllers/RegistroSintomaController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/', authMiddleware, RegistroSintomaController.criar);
router.get('/', authMiddleware, RegistroSintomaController.listar);
router.put('/:id', authMiddleware, RegistroSintomaController.editar);
router.delete('/:id', authMiddleware, RegistroSintomaController.deletar);

module.exports = router;