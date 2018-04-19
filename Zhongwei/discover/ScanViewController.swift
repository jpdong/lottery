//
//  ScanViewController.swift
//  Zhongwei
//
//  Created by eesee on 2018/1/25.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

class ScanViewController:UIViewController,AVCaptureMetadataOutputObjectsDelegate{
    var scanRectView:UIView!
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    var presenter:DiscoverPresenter!
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DiscoverPresenter()
        fromCamera()
    }
    
    //通过摄像头扫描
    func fromCamera() {
        do{
            self.device = AVCaptureDevice.default(for: AVMediaType.video)
            self.input = try AVCaptureDeviceInput(device: device)
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.session = AVCaptureSession()
            if UIScreen.main.bounds.size.height<500 {
                self.session.sessionPreset = AVCaptureSession.Preset.vga640x480
            }else{
                self.session.sessionPreset = AVCaptureSession.Preset.high
            }
            
            self.session.addInput(self.input)
            self.session.addOutput(self.output)
            
            self.output.metadataObjectTypes = supportedCodeTypes
            
            //计算中间可探测区域
            let windowSize = UIScreen.main.bounds.size;
            let scanSize = CGSize(width:windowSize.width*3/4,
                                  height:windowSize.width*3/4)
            var scanRect = CGRect(x:(windowSize.width-scanSize.width)/2,
                                  y:(windowSize.height-scanSize.height)/2,
                                  width:scanSize.width, height:scanSize.height)
            //计算rectOfInterest 注意x,y交换位置
            scanRect = CGRect(x:scanRect.origin.y/windowSize.height,
                              y:scanRect.origin.x/windowSize.width,
                              width:scanRect.size.height/windowSize.height,
                              height:scanRect.size.width/windowSize.width)
            //设置可探测区域
            self.output.rectOfInterest = scanRect
            
            self.preview = AVCaptureVideoPreviewLayer(session:self.session)
            self.preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.preview.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(self.preview, at:0)
            
            //添加中间的探测区域绿框
            self.scanRectView = UIView();
            self.view.addSubview(self.scanRectView)
            self.scanRectView.frame = CGRect(x:0, y:0, width:scanSize.width,
                                             height:scanSize.height)
            self.scanRectView.center = CGPoint(x:UIScreen.main.bounds.midX,
                                               y:UIScreen.main.bounds.midY)
            self.scanRectView.layer.borderColor = UIColor.green.cgColor
            self.scanRectView.layer.borderWidth = 1
            
            //开始捕获
            self.session.startRunning()
            
            //放大
            do {
                try self.device!.lockForConfiguration()
            } catch _ {
                NSLog("Error: lockForConfiguration.");
            }
            self.device!.videoZoomFactor = 1.5
            self.device!.unlockForConfiguration()
            
        }catch _ as NSError{
            //打印错误消息
            let alertController = UIAlertController(title: "提醒",
                                                    message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机",
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if (supportedCodeTypes.contains(metadataObj.type)){
            let barCodeObject = preview?.transformedMetadataObject(for: metadataObj)
            if metadataObj.stringValue != nil {
                let code = metadataObj.stringValue as! String
                session.stopRunning()
                presenter.getPrizeData(code:code)
                .observeOn(MainScheduler.instance)
                    .subscribe(onNext:{
                        result in
                        let alertView = UIAlertController(title:result.title, message:result.message, preferredStyle:.alert)
                        let confirm = UIAlertAction(title:"确定", style:.default){
                            action in
                            self.session.startRunning()
                        }
                        alertView.addAction(confirm)
                        self.present(alertView,animated: true,completion: nil)
                    })
            }
        }
    }
}


