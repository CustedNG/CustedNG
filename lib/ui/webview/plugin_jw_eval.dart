import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';
import 'package:flutter/cupertino.dart';

const jwEvalHelper = '''
(function () {
    var sleep = (ms) => new Promise((resolve) => {
        setTimeout(resolve, ms);
    });

    function evalGoToNext() {
        if (evalIsStarted() == false) {
            alert('请先阅读说明并确认');
            return false;
        }

        for (e of document.querySelectorAll('li.el-select-dropdown__item')) {
            if (e.innerText.includes('未评')) {
                e.click();
                return true;
            }
        }

        alert('似乎评教已全部完成')
        return false;
    }

    function evalSelectAll() {
        document.querySelectorAll('div[role=radiogroup]').forEach(e => {
            e.querySelector('label:nth-child(1)').click();
        });
    }

    function evalSubmit() {
        document.querySelector('button.app-confirm.el-button--medium').click()
    }

    function evalIsStarted() {
        return document.body.innerText.indexOf('评教说明') == -1;
    }

    async function evalOneClick() {
        container().innerHTML = '评教中...'

        while (evalGoToNext()) {
            await sleep(2000);
            evalSelectAll();
            await sleep(2000);
            evalSubmit();
            await sleep(1000);
        }

        container(true)
    }

    function button(text, handler) {
        var btn = document.createElement('div');

        btn.innerHTML = text;
        btn.onclick = handler;

        btn.style.fontSize = '15px';
        btn.style.color = '#1a91eb';
        btn.style.fontWeight = '600';
        btn.style.display = 'flex'
        btn.style.flexDirection = 'row'
        btn.style.alignItems = 'center'
        btn.style.justifyContent = 'flex-start'
        btn.style.marginTop = '20px'
        btn.style.cursor = 'pointer'
        return btn;
    }

    function container(forceRebuild) {
        var currentContainer = document.querySelector('div.jwEvalHelper')
        if (currentContainer != null) {
            if (forceRebuild == true) {
                currentContainer.parentElement.removeChild(currentContainer)
            } else {
                return currentContainer;
            }
        }

        var body = document.querySelector('body')
        var container = document.createElement('div');
        body.appendChild(container);
        container.classList.add('jwEvalHelper')
        container.innerHTML = '评教助手';

        container.style.position = 'fixed';
        container.style.zIndex = 100;

        container.style.bottom = '20px';
        container.style.left = '20px';
        container.style.height = '270px';
        container.style.width = '100px';
        container.style.padding = '15px';

        container.style.backgroundColor = 'rgba(255, 255, 255, 0.5)';
        container.style.boxShadow = '0px 0px 5px #aaa';

        container.style.display = 'flex';
        container.style.alignItems = 'center';
        container.style.flexDirection = 'column';

        container.appendChild(button('全选', evalSelectAll))
        container.appendChild(button('提交', evalSubmit))
        container.appendChild(button('下个未评', evalGoToNext))
        container.appendChild(button('一键评教', evalOneClick))

        return container;
    }

    function activate() {
        var evalPath = '/ClientStudent/EvaluateServices/StudentEvaluate'
        if (document.location.pathname == evalPath) {
            container().style.display = 'flex';
        } else {
            container().style.display = 'none';
        }
    }

    setInterval(activate, 500);
})();
''';

class PluginJwEval extends Webview2Plugin{
  bool shouldActivate(Uri uri) {
    return uri.host.startsWith('jwgl');
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    webview.evalJavascript(jwEvalHelper);
  }
}
