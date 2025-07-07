//
//  MyWebViewController.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

import UIKit
import WebKit
internal import SnapKit
import Foundation

enum PlatformURL: String {
    case google = "https://www.google.com/"
    case musinsa = "https://www.musinsa.com/search/goods?keyword=%E3%85%81%E3%84%B4%E3%85%87%E3%85%81%E3%84%B4%E3%85%87&gf=A&keywordType=keyword&suggestKeyword=%EB%AA%BD%EB%AA%BD"
    case ably = "https://m.a-bly.com/search?screen_name=SEARCH_RESULT&keyword=%EC%96%91%EB%A7%90&search_type=POPULAR"
    case zigzag = "https://zigzag.kr"
    case a4910 = "https://4910.kr"
}

class MyWebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. WKWebView 설정
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        // 델리게이트 설정: self (MyWebViewController)가 내비게이션을 처리
        webView.navigationDelegate = self
        
        // 웹뷰를 뷰에 추가
        view.addSubview(webView)
        
        // 웹뷰 레이아웃 설정 (Auto Layout 예시)
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        // 웹 페이지 로드
        let request = URLRequest(url: url)
        webView.load(request)
    }
    // 이 메서드가 웹뷰 내에서 발생하는 모든 URL 이동 시도를 감지합니다.
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            // 현재 내비게이션 액션의 요청 URL을 가져옵니다.
            if let url = navigationAction.request.url {
                let urlString = url.absoluteString
                print("--- URL 감지: \(urlString) ---")

                // 여기에 감지된 URL에 대한 추가 로직을 구현할 수 있습니다.
                // 예를 들어, 특정 딥링크 스키마를 감지하여 앱 내에서 처리하거나,
                // 외부 웹사이트 링크인 경우 Safari로 열도록 할 수 있습니다.

                // 예시: Zigzag 딥링크 스키마(zigzag://) 감지
                if url.scheme == "zigzag" {
                    print(">>>>> 지그재그 딥링크 스키마 감지! 앱에서 처리할지 결정합니다.")
                    
                    // 앱에서 딥링크를 처리하는 로직을 여기에 추가합니다.
                    // (예: 해당 딥링크에 맞는 앱의 특정 화면으로 이동)
                    
                    // 웹뷰의 내비게이션을 취소하고 앱이 딥링크를 처리하도록 합니다.
                    decisionHandler(.cancel)
                    return // 여기서 함수 종료
                }
                
                // 예시: 다른 웹사이트로 이동하는 링크를 감지
                // 현재 웹뷰의 호스트와 다른 호스트로 이동하려고 할 때 (외부 링크)
                if let currentHost = webView.url?.host,
                   let newHost = url.host,
                   newHost != currentHost {
                    print(">>>>> 외부 웹사이트 링크 감지! 웹뷰가 아닌 Safari로 열지 선택할 수 있습니다.")
                    // UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    // decisionHandler(.cancel) // Safari로 열고 웹뷰 내 내비게이션 취소
                    // return
                }
            }
            
            // 위에 해당하는 특별한 URL이 아니라면, 웹뷰가 정상적으로 페이지를 로드하도록 허용합니다.
            decisionHandler(.allow)
        }

        // 웹뷰 로드가 시작될 때 (옵션)
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if let url = webView.url {
                print("웹뷰 로드 시작: \(url.absoluteString)")
            }
        }

        // 웹뷰 로드가 완료되었을 때 (옵션)
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url {
                print("웹뷰 로드 완료: \(url.absoluteString)")
            }
        }

        // 웹뷰 로드 중 에러 발생 시 (옵션)
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("웹뷰 로드 실패 (임시): \(error.localizedDescription)")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("웹뷰 로드 실패: \(error.localizedDescription)")
        }
        
        // WKWebView.isLoading 관찰자
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.isLoading) {
                if webView.isLoading {
                    print("웹뷰가 현재 로딩 중입니다...")
                } else {
                    print("웹뷰 로딩 상태: 완료")
                }
            }
        }
        
        deinit {
            // 옵저버를 제거하여 메모리 누수를 방지합니다.
            webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
        }
    }
