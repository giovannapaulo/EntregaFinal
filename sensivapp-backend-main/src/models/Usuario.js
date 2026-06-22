const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Usuario = sequelize.define('Usuario', {
    id_usuario: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    nome: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    email: {
        type: DataTypes.STRING(100),
        allowNull: false,
        unique: true
    },
    senha: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    tipo_usuario: {
        type: DataTypes.ENUM('paciente', 'profissional', 'administrador'),
        allowNull: true,
        defaultValue: 'paciente'
    },
    url_foto: {
        type: DataTypes.STRING(255),
        allowNull: true
    }
}, {
    tableName: 'Usuarios', 
    timestamps: false    
});

module.exports = Usuario;