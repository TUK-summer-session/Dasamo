const http = require('http');
const express = require('express');
const app = express();
const cors = require('cors');

// 포트가 딱히 없으면 3000
const port = process.env.PORT || 3000;
const router = require('./src/routes/router');
const bodyParser = require('body-parser');

// cors 임시 전체 허용
app.use(cors());

// JSON 형식의 데이터 처리 - router보다 이거 먼저 써야함 전체 적용을 위해
app.use(bodyParser.json());
// url 인코딩 데이터 처리
app.use(bodyParser.urlencoded({extended: true}));
// 라우터를 애플리케이션에 등록
app.use('/', router);

app.listen(port, () => {
    console.log(`웹서버 구동... ${port}`);
});

// console.log("hello");