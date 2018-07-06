
import {CheckboxShape} from 'shape/widget/Checkbox'
import {TextShape}   from 'shape/Text'
import * as util     from 'shape/util'
import * as layers   from 'view/layers'
import {Widget}      from 'widget/Widget'



export class Checkbox extends Widget
    initModel: ->
        model = super()
        model.minHeight = 20
        model.minWidth = 20
        model.maxHeight = 20
        model.maxWidth = 50
        model.value = false
        model

    prepare: =>
        @addDef 'checkbox', new CheckboxShape null, @

    update: =>
        @updateDef 'checkbox',
            checked:     @model.value
            topLeft:     not (@model.siblings.top or @model.siblings.left)
            topRight:    not (@model.siblings.top or @model.siblings.right)
            bottomLeft:  not (@model.siblings.bottom or @model.siblings.left)
            bottomRight: not (@model.siblings.bottom or @model.siblings.right)
            width:       @model.width
            height:      @model.height

    adjust: (view) =>
        if @changed.height then @view('checkbox').position.y = -@model.height/2

    registerEvents: (view) =>
        view.addEventListener 'click', (e) =>
            @set value: not @model.value
            @pushEvent
                tag: 'PortControlEvent'
                content:
                    cls: 'Bool'
                    value: @model.value
