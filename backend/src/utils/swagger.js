"use strict";
exports.__esModule = true;
// import swaggerAutogen from 'swagger-autogen';
var swaggerAutogen = require("swagger-autogen");
var doc = {
    info: {
        version: 'v1.0.0',
        title: 'Inventory Endpoints',
        description: 'View All Endpoints of Inventory API'
    },
    servers: [
        {
            url: 'http://localhost:3000',
            description: ''
        },
    ],
    components: {
        securitySchemes: {
            bearerAuth: {
                type: 'http',
                scheme: 'bearer'
            }
        }
    }
};
var outputFile = '../swagger_output.json';
var endpointsFiles = ['./src/utils/routes.ts'];
swaggerAutogen({ openapi: '3.0.0' })(outputFile, endpointsFiles, doc);
