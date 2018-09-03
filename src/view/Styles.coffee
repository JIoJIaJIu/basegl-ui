import {ContainerComponent} from 'abstract/ContainerComponent'
import {HorizontalLayout}   from 'widget/HorizontalLayout'
import {VerticalLayout}     from 'widget/VerticalLayout'
import {TextContainer}      from 'view/Text'
import {ContinousSlider}    from 'widget/Slider'


export class Styles extends ContainerComponent
    initModel: =>
        connection_lineWidth: 2
    
    enable: =>
        @addDef 'vertical', VerticalLayout,
            width: 300

        children = for own key, val of @model
            minVal =
                if val < -1
                    -100
                else if val < 0
                    -1
                else
                    0
            maxVal =
                if val > 1
                    100
                else
                    1 
            cons: HorizontalLayout
            height: 10
            children:
                [
                    cons: TextContainer
                    text: key
                ,
                    cons: ContinousSlider
                    value: val
                    min: minVal
                    max: maxVal
                ]
        @updateDef 'vertical', children: children

        for own key, val of @def('vertical').model.children
            name = val.children[0].text
            @def('vertical').def(key).def(1).addEventListener 'value', (e) =>
                x = {}
                x[name] = e.detail
                @set x

        dragHandler = (e) =>
            if e.button != 0 then return
            moveNodes = (e) =>
                @withScene (scene) =>
                    x = @__view.position.x + e.movementX * scene.camera.zoomFactor
                    y = @__view.position.y - e.movementY * scene.camera.zoomFactor
                    @__view.position.xy = [x, y]

            dragFinish = =>
                @pushEvent
                    tag: 'NodeMoveEvent'
                    position: @model.position
                window.removeEventListener 'mouseup', dragFinish
                window.removeEventListener 'mousemove', moveNodes
            window.addEventListener 'mouseup', dragFinish
            window.addEventListener 'mousemove', moveNodes
        @view('vertical').addEventListener 'mousedown', dragHandler