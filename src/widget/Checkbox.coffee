
import {CheckboxShape} from 'shape/Checkbox'
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
        model.maxWidth = 20
        model.width  = 20
        model.height = 20
        model.min = null
        model.max = null
        model.value = null
        model

    prepare: =>
        @addDef 'checkbox', new CheckboxShape null, @

    update: =>
        @updateDef 'checkbox',
            level:       (@model.value - @model.min)/(@model.max - @model.min)
            topLeft:     not (@model.siblings.top or @model.siblings.left)
            topRight:    not (@model.siblings.top or @model.siblings.right)
            bottomLeft:  not (@model.siblings.bottom or @model.siblings.left)
            bottomRight: not (@model.siblings.bottom or @model.siblings.right)
            width:       @model.width
            height:      @model.height

    adjust: (view) =>
        if @changed.height then @view('checkbox').position.y = -@model.height/2

    registerEvents: =>
