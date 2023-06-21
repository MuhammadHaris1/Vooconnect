//
//  BeautyView.swift
//  Vooconnect
//
//  Created by Mac on 11/06/2023.
//

import SwiftUI
import ARGear

struct BeautyView: View {
    @State private var isLongPressing = false
    
    
    let kBeautyViewCompareIconName = "icCompare"
    let kBeautyViewResetIconName = "icRefresh"
    
    
    let iconNames = [
        "icVline",
        "icFacewidth",
        "icFacelength",
        "icChinlength",
        "icEyesize",
        "icEyewidth",
        "icNosenarrow",
        "icAla",
        "icNoselength",
        "icMouthsize",
        "icEyeback",
        "icEyeangle",
        "icLips",
        "icSkin",
        "icDarkcircle",
        "icWrinkle"
    ]
    @State var selectedIndex = 0
    @State var selectedIcon = 0
    @State private var value: Float = 0
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        VStack {
            HStack{
                Slider(value: $value, in: 0...100)
                    .onChange(of: value) { newValue in
                        print(value)
                        guard let beautyType = ARGContentItemBeauty(rawValue: Int(newValue)) else {
                            return
                        }
                        BeautyManager.shared.setBeauty(type: beautyType, value: newValue)
//                        print("Done")
                    }
                Text("\(Int(value))")
                Image("icCompareBlack").resizable().frame(width: 40, height: 40)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onChanged { isPressing in
                                isLongPressing = isPressing
                                if isLongPressing {
                                    BeautyManager.shared.off()
                                }
                            }
                            .onEnded { _ in
                                // Perform any actions when the long press gesture ends
                                print("Long press ended")
                                BeautyManager.shared.on()
                            }
                    )
                Image("icRefreshBlack").resizable().frame(width: 40, height: 40)
                    .onTapGesture {
                        BeautyManager.shared.setDefault()
                        
                        if selectedIndex != 0  {
                            let beautyValue = BeautyManager.shared.getBeautyValue(type: ARGContentItemBeauty(rawValue: selectedIndex) ?? .vline)
                            value = beautyValue
                        }
                    }
                
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(iconNames.enumerated()), id: \.offset) { (index,item) in
                        Image(getIconName(index: index, withLanguageCode: true)).resizable().frame(width: 40,height: 40, alignment: .center).padding(.all, 10)
                            .onTapGesture {
                                selectedIndex = index
                                print("Selected Index \(selectedIndex)")
                            }
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(selectedIndex == index ? Color.black : Color.clear, lineWidth: 2)
//                            )
                    }
                }.frame(height: 50)
            }
        }.padding(.horizontal, 20).onAppear {
            open()
        }
    }
    func open() {
        var beautyIndex = 0
        self.value = BeautyManager.shared.getBeautyValue(type: ARGContentItemBeauty(rawValue: beautyIndex)!)
        BulgeManager.shared.off()
        ContentManager.shared.clearContent()
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        setRatio(ratio)
        
        self.setButtons(ratio: ratio)
//        self.beautyCollectionView.setRatio(ratio)
    }
    
    func setButtons(ratio: ARGMediaRatio) {
        
        var compareButtonImageName = self.kBeautyViewCompareIconName
        var resetButtonImageName = self.kBeautyViewResetIconName
        
        var imageColorString = ""
        if ratio == ._16x9 {
            imageColorString = "White"
        } else {
            imageColorString = "Black"
        }
        compareButtonImageName.append(imageColorString)
        resetButtonImageName.append(imageColorString)

//        self.compareButton.setImage(UIImage(named: compareButtonImageName), for: .normal)
//        self.compareButton.setImage(UIImage(named: compareButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)
//
//        self.resetButton.setImage(UIImage(named: resetButtonImageName), for: .normal)
//        self.resetButton.setImage(UIImage(named: resetButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)
    }
    
    
    
    
    
    func getIconName(index: Int, withLanguageCode: Bool) -> String {
        var iconName = iconNames[index]
        if (ARGMediaRatio._16x9.rawValue != 0) {
            iconName.append("White")
        } else {
            iconName.append("Black")
        }
        if index == selectedIndex {
            iconName.append("")
        }
        else {
            iconName.append("Off")
        }
        if withLanguageCode {
            iconName.append("_".appendLanguageCode())
        }
        return iconName;
    }
    
}

struct BeautyView_Previews: PreviewProvider {
    static var previews: some View {
        BeautyView()
    }
}
