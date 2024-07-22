const express = require('express');
const app = express();
const path = require('path');
const router = require('./src/routes/router');
const bodyParser = require('body-parser');

// JSON 형식의 데이터 처리
app.use(bodyParser.json());
// URL 인코딩 데이터 처리
app.use(bodyParser.urlencoded({ extended: true }));

// 정적 파일 제공 설정 (업로드된 파일)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// 라우터를 애플리케이션에 등록
app.use('/', router);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`웹서버 구동... ${port}`);
});
