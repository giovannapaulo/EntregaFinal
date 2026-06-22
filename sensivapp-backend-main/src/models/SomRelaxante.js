const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const SomRelaxante = sequelize.define('SomRelaxante', {
    id_som: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    titulo: {
        type: DataTypes.STRING(150),
        allowNull: false
    },
    url_arquivo: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    duracao_segundos: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    categoria: {
        type: DataTypes.STRING(50),
        allowNull: false
    }
}, {
    tableName: 'Sons_Relaxantes',
    timestamps: false
});

module.exports = SomRelaxante;