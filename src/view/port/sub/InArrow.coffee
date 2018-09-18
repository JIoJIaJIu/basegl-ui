import {animateComponent} from 'shape/Animation'
import {InPortShape}      from 'shape/port/In'
import {TextContainer}    from 'view/Text'
import {Subport}          from 'view/port/sub/Base'
import * as subport       from 'view/port/sub/Base'


export class InArrow extends Subport
    initModel: =>
        angle: 0
        hovered: false
        name: ''
        typeName: ''
        radius: 0

    prepare: =>
        @addDef 'port', InPortShape, angle: @model.angle

    update: =>
        @autoUpdateDef 'name', TextContainer,
            text: @model.name
            align: 'right'
            border: @style.port_nameBorder
            frameColor:
                [ @style.port_borderColor_h, @style.port_borderColor_s
                , @style.port_borderColor_l, @style.port_borderColor_a
                ]
        @autoUpdateDef 'typeName', TextContainer, if @model.hovered
            text: @model.typeName
            align: 'right'
            border: @style.port_typeBorder

    adjust: (view) =>
        if @changed.radius
            @view('port').position.y = @model.radius
            namePosition = [- subport.nameXOffset(@style) - @model.radius, 0]
            @view('name').position.xy = namePosition
        if @changed.angle
            @view('port').rotation.z = @model.angle
            @view('name').rotation.z = @model.angle - Math.PI/2
        if @view('typeName')?
            @view('typeName').rotation.z = @model.angle - Math.PI/2
            typeNamePosition = [- subport.typeNameXOffset(@style) - @model.radius, - subport.typeNameYOffset(@style)]
            @view('typeName').position.xy = typeNamePosition

    registerEvents: (view) =>
        super view
        view.addEventListener 'mousedown', (e) =>
            e.stopPropagation()
            @pushEvent e

    connectSources: =>
        @__onNameChange()
        @__onTypeNameChange()
        @__onRadiusChange()
        @__onColorChange()
        @__onHoverChange()
        @addDisposableListener @parent, 'name', => @__onNameChange()
        @addDisposableListener @parent, 'typeName', => @__onTypeNameChange()
        @addDisposableListener @parent, 'radius', => @__onRadiusChange()
        @addDisposableListener @parent, 'color', => @__onColorChange()
        @addDisposableListener @parent.parent.parent, 'hovered', => @__onHoverChange() #TODO: Refactor

    __onNameChange: =>
        @set name: @parent.model.name
    __onTypeNameChange: =>
        @set typeName: @parent.model.typeName
    __onRadiusChange: =>
        @set radius: @parent.model.radius
    __onColorChange: =>
        @updateDef 'port', color: @parent.model.color
    __onHoverChange: =>
        @set hovered: @parent.parent.parent.model.hovered
