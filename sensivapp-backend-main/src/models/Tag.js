const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Tag = sequelize.define('Tag', {
    id_tag: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nome_tag: {
        type: DataTypes.STRING(50),
        allowNull: false,
        unique: true
    },
    tipo_tag: {
        type: DataTypes.ENUM('sensibilidade', 'sintoma', 'geral'),
        allowNull: true
    }
}, {
    tableName: 'Tags',
    timestamps: false
});

module.exports = Tag;