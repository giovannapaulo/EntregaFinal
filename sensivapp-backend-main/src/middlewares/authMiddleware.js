const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).send({ error: 'Token não fornecido' });

    const parts = authHeader.split(' ');
    const [scheme, token] = parts;

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) return res.status(401).send({ error: 'Token inválido' });
        
        req.id_paciente = decoded.id; 
        return next();
    });
};