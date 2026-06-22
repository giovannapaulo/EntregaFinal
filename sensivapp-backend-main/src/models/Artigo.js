const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Artigo = sequelize.define('Artigo', {
    id_artigo: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    titulo: {
        type: DataTypes.STRING(150),
        allowNull: false
    },
    autor: {
        type: DataTypes.STRING(100),
        allowNull: true
    },
    conteudo_texto: {
        type: DataTypes.TEXT('long'), 
        allowNull: false
    },
    data_publicacao: {
        type: DataTypes.DATEONLY,
        allowNull: false
    }
}, {
    tableName: 'Artigos',
    timestamps: false
});

module.exports = Artigo;