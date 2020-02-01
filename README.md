<p align="center">
<img src="https://raw.githubusercontent.com/xtyxtyx/custed/master/screenshot/CustedNG.png">
</p>

<p align="center">
    <img alt="Build Status" src="https://api.codemagic.io/apps/5e34f30dcb13955d9f85f43f/5e34f30dcb13955d9f85f43e/status_badge.svg">
    <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/xtyxtyx/custed">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues-raw/xtyxtyx/custed">
    <img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/xtyxtyx/custed">
</p>

## CustedNG


### 架构

```       
+--------------------------------------------------------------+                  
|                              UI                              |                  
+--------------------------------------------------------------+                  
+--------------------------------------------------------------+                  
|                     View Model (provider)                    |                  
+--------------------------------------------------------------+                  
+-----------------------+ +---------------+ +------------------+                  
| Service (http client) | |     User      | |                  |                  
+-----------------------+ +---------------+ |                  |                  
+-------------------------------------------+                  |                  
|                        Database (store)                      |                  
+--------------------------------------------------------------+   
```

### 设计原则

- **拥抱变化**: 以最小代价应对上游变更
- **跨平台**: 用 PlatformApi 封装平台接口, 保持对ios, andriod, web, osx (以及之后的 linux, etc) 的兼容性
- **性能**: 将运算量大的函数放入 isolate 中执行
- _More_