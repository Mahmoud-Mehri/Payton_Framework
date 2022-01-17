object MainFrm: TMainFrm
  Left = 0
  Top = 0
  ClientHeight = 514
  ClientWidth = 813
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 813
    Height = 67
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
    object Button1: TButton
      Left = 192
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object EditorPanel: TPanel
    Left = 201
    Top = 67
    Width = 303
    Height = 411
    Align = alClient
    BevelOuter = bvLowered
    Constraints.MinWidth = 300
    TabOrder = 1
    DesignSize = (
      303
      411)
    object Label1: TLabel
      Left = 6
      Top = 6
      Width = 71
      Height = 13
      Caption = 'Python Script :'
    end
    object Editor: TSynEdit
      Left = 5
      Top = 25
      Width = 295
      Height = 347
      Align = alCustom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 0
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Highlighter = PyHighlighter
      Lines.Strings = (
        'ArrayVar.Value = bytearray()'
        'ArrayVar.Value.append(0x81)'
        'ArrayVar.Value.append(0x31)'
        'ArrayVar.Value.append(0x37)')
    end
    object ExecBtn: TBitBtn
      Left = 5
      Top = 378
      Width = 75
      Height = 27
      Anchors = [akLeft, akBottom]
      Caption = 'Execute'
      TabOrder = 1
      OnClick = ExecBtnClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 478
    Width = 813
    Height = 36
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 2
  end
  object VarPanel: TPanel
    Left = 0
    Top = 67
    Width = 201
    Height = 411
    Align = alLeft
    BevelOuter = bvLowered
    TabOrder = 3
    object VarPC: TPageControl
      Left = 1
      Top = 1
      Width = 199
      Height = 409
      ActivePage = VarPage
      Align = alClient
      TabOrder = 0
      object VarPage: TTabSheet
        Caption = 'Variables'
        DesignSize = (
          191
          381)
        object NewVarGBox: TGroupBox
          Left = 3
          Top = 3
          Width = 185
          Height = 104
          Caption = ' New Variable '
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 24
            Width = 34
            Height = 13
            Caption = 'Name :'
          end
          object Label3: TLabel
            Left = 9
            Top = 77
            Width = 33
            Height = 13
            Caption = 'Value :'
          end
          object Label4: TLabel
            Left = 11
            Top = 50
            Width = 31
            Height = 13
            Caption = 'Type :'
          end
          object VarNameEdit: TEdit
            Left = 48
            Top = 20
            Width = 129
            Height = 21
            TabOrder = 0
          end
          object VarCreateBtn: TBitBtn
            Left = 131
            Top = 72
            Width = 47
            Height = 25
            Caption = 'Create'
            TabOrder = 1
            OnClick = VarCreateBtnClick
          end
          object VarValueEdit: TEdit
            Left = 48
            Top = 74
            Width = 77
            Height = 21
            TabOrder = 2
          end
          object VarTypeCBox: TComboBox
            Left = 48
            Top = 47
            Width = 129
            Height = 21
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 3
            Text = 'String'
            Items.Strings = (
              'String'
              'Integer'
              'Boolean')
          end
        end
        object VarList: TListBox
          Left = 3
          Top = 113
          Width = 185
          Height = 234
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          TabOrder = 1
        end
        object VarDeleteBtn: TBitBtn
          Left = 3
          Top = 353
          Width = 54
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Delete'
          TabOrder = 2
          OnClick = VarDeleteBtnClick
        end
      end
      object Records: TTabSheet
        Caption = 'Functions'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label6: TLabel
          Left = 3
          Top = 68
          Width = 115
          Height = 13
          Caption = 'Python Function Name :'
        end
        object Label7: TLabel
          Left = 3
          Top = 116
          Width = 154
          Height = 13
          Caption = 'Argumans ( Seperate with "," ) :'
        end
        object Label8: TLabel
          Left = 3
          Top = 3
          Width = 89
          Height = 13
          Caption = 'Open Python File :'
        end
        object Label9: TLabel
          Left = 3
          Top = 49
          Width = 185
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '----------------------------------------------'
        end
        object Label10: TLabel
          Left = 3
          Top = 216
          Width = 110
          Height = 13
          Caption = 'Function Result Value :'
        end
        object FuncNameEdit: TEdit
          Left = 3
          Top = 87
          Width = 185
          Height = 21
          TabOrder = 2
        end
        object FuncArgsEdit: TEdit
          Left = 3
          Top = 135
          Width = 185
          Height = 21
          TabOrder = 3
        end
        object FuncExecBtn: TBitBtn
          Left = 3
          Top = 173
          Width = 94
          Height = 27
          Caption = 'Execute Function'
          TabOrder = 4
          OnClick = FuncExecBtnClick
        end
        object PyFileEdit: TEdit
          Left = 3
          Top = 22
          Width = 154
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
        object PyOpenBtn: TBitBtn
          Left = 161
          Top = 19
          Width = 27
          Height = 27
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000120B0000120B00000000000000000000FF00FF0274AC
            0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274
            AC0274ACFF00FFFF00FF0274AC138AC457B7E06BCBF84BBFF74ABFF74ABFF74A
            BFF74ABFF64ABFF74ABFF64BC0F72398CC0274ACFF00FFFF00FF0274AC33AAE0
            2392C489D9FA54C7F854C7F753C7F854C7F754C7F854C7F854C7F853C7F7279D
            CE6ACBE50274ACFF00FF0274AC57CAF80274AC99E3FB5ED1FA5ED1FA5ED1FA5E
            D1FA5ED1FA5FD1FA5ED1F85ED1F82CA1CE99EDF70274ACFF00FF0274AC5ED3FA
            0B81B782D5EF79E0FA6ADCFA69DCFB69DCFB6ADCFB69DCFB69DCFA6ADDFB2FA6
            CF9FF0F70274ACFF00FF0274AC68DAFB2BA4D14AB2D797EBFC74E5FB74E5FB74
            E5FC74E5FC74E5FB74E5FC046B0B33A9CFA3F4F752BBD70274AC0274AC70E3FB
            5CD1EF1184B6FCFFFFB8F4FEBAF4FEBAF4FEBAF4FEB8F4FE046B0B25AA42046B
            0BD4F7FACAF3F70274AC0274AC7AEBFE7AEBFC0A7FB50274AC0274AC0274AC02
            74AC0274AC046B0B38CE6547E77F29B44A046B0B0274AC0274AC0274AC83F2FE
            82F3FE82F3FE83F2FC83F3FE82F3FE83F2FE046B0B2DC0513FDC6E3ED86E46E5
            7B28B04A046B0BFF00FF0274ACFEFEFE89FAFF89FAFE89FAFE8AF8FE8AFAFE04
            6B0B046B0B046B0B046B0B3CD86A2EBF53046B0B046B0B046B0BFF00FF0274AC
            FEFEFE8FFEFF8FFEFF8FFEFF0273A32BA4D12BA4D12BA4D1046B0B35D35E20A7
            3A046B0BFF00FFFF00FFFF00FFFF00FF0274AC0274AC0274AC0274ACFF00FFFF
            00FFFF00FFFF00FF046B0B28C24A046B0BFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF046B0B17A42B19A730046B
            0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FF046B0B11A122046B0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FF046B0B046B0B046B0B046B0BFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF046B0B046B0B04
            6B0B046B0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          TabOrder = 1
          OnClick = PyOpenBtnClick
        end
        object ResultEdit: TEdit
          Left = 3
          Top = 235
          Width = 185
          Height = 21
          ReadOnly = True
          TabOrder = 5
        end
      end
      object ClassPage: TTabSheet
        Caption = 'Classes'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label11: TLabel
          Left = 3
          Top = 49
          Width = 185
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '----------------------------------------------'
        end
        object Label12: TLabel
          Left = 3
          Top = 3
          Width = 89
          Height = 13
          Caption = 'Open Python File :'
        end
        object Label13: TLabel
          Left = 9
          Top = 98
          Width = 56
          Height = 13
          Caption = 'Attr Name :'
        end
        object Label14: TLabel
          Left = 13
          Top = 158
          Width = 52
          Height = 13
          Caption = 'AttrValue :'
        end
        object Label15: TLabel
          Left = 3
          Top = 70
          Width = 62
          Height = 13
          Caption = 'Class Name :'
        end
        object ClassOpenFileBtn: TBitBtn
          Left = 161
          Top = 19
          Width = 27
          Height = 27
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000120B0000120B00000000000000000000FF00FF0274AC
            0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274AC0274
            AC0274ACFF00FFFF00FF0274AC138AC457B7E06BCBF84BBFF74ABFF74ABFF74A
            BFF74ABFF64ABFF74ABFF64BC0F72398CC0274ACFF00FFFF00FF0274AC33AAE0
            2392C489D9FA54C7F854C7F753C7F854C7F754C7F854C7F854C7F853C7F7279D
            CE6ACBE50274ACFF00FF0274AC57CAF80274AC99E3FB5ED1FA5ED1FA5ED1FA5E
            D1FA5ED1FA5FD1FA5ED1F85ED1F82CA1CE99EDF70274ACFF00FF0274AC5ED3FA
            0B81B782D5EF79E0FA6ADCFA69DCFB69DCFB6ADCFB69DCFB69DCFA6ADDFB2FA6
            CF9FF0F70274ACFF00FF0274AC68DAFB2BA4D14AB2D797EBFC74E5FB74E5FB74
            E5FC74E5FC74E5FB74E5FC046B0B33A9CFA3F4F752BBD70274AC0274AC70E3FB
            5CD1EF1184B6FCFFFFB8F4FEBAF4FEBAF4FEBAF4FEB8F4FE046B0B25AA42046B
            0BD4F7FACAF3F70274AC0274AC7AEBFE7AEBFC0A7FB50274AC0274AC0274AC02
            74AC0274AC046B0B38CE6547E77F29B44A046B0B0274AC0274AC0274AC83F2FE
            82F3FE82F3FE83F2FC83F3FE82F3FE83F2FE046B0B2DC0513FDC6E3ED86E46E5
            7B28B04A046B0BFF00FF0274ACFEFEFE89FAFF89FAFE89FAFE8AF8FE8AFAFE04
            6B0B046B0B046B0B046B0B3CD86A2EBF53046B0B046B0B046B0BFF00FF0274AC
            FEFEFE8FFEFF8FFEFF8FFEFF0273A32BA4D12BA4D12BA4D1046B0B35D35E20A7
            3A046B0BFF00FFFF00FFFF00FFFF00FF0274AC0274AC0274AC0274ACFF00FFFF
            00FFFF00FFFF00FF046B0B28C24A046B0BFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF046B0B17A42B19A730046B
            0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FF046B0B11A122046B0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FF046B0B046B0B046B0B046B0BFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF046B0B046B0B04
            6B0B046B0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          TabOrder = 1
          OnClick = ClassOpenFileBtnClick
        end
        object ClassFileEdit: TEdit
          Left = 3
          Top = 22
          Width = 154
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
        object GetClassBtn: TBitBtn
          Left = 0
          Top = 122
          Width = 188
          Height = 27
          Caption = 'Get Value of Attribute from Class'
          TabOrder = 4
          OnClick = GetClassBtnClick
        end
        object AttrNameEdit: TEdit
          Left = 71
          Top = 95
          Width = 117
          Height = 21
          TabOrder = 3
        end
        object AttrValueEdit: TEdit
          Left = 71
          Top = 155
          Width = 117
          Height = 21
          ReadOnly = True
          TabOrder = 5
        end
        object ClassNameEdit: TEdit
          Left = 71
          Top = 68
          Width = 117
          Height = 21
          TabOrder = 2
        end
      end
    end
  end
  object OutputPanel: TPanel
    Left = 504
    Top = 67
    Width = 309
    Height = 411
    Align = alRight
    BevelOuter = bvLowered
    Constraints.MinWidth = 250
    TabOrder = 4
    DesignSize = (
      309
      411)
    object Label5: TLabel
      Left = 6
      Top = 6
      Width = 41
      Height = 13
      Caption = 'Output :'
    end
    object OutputMemo: TMemo
      Left = 6
      Top = 24
      Width = 299
      Height = 381
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object PyHighlighter: TSynPythonSyn
    KeyAttri.Foreground = clNavy
    Left = 664
    Top = 400
  end
  object PyEngine: TPythonEngine
    IO = PythonGUIInputOutput
    Left = 664
    Top = 200
  end
  object PythonGUIInputOutput: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = OutputMemo
    Left = 664
    Top = 137
  end
  object PythonModule: TPythonModule
    Engine = PyEngine
    ModuleName = 'sample'
    Errors = <>
    Left = 664
    Top = 265
  end
  object FuncResVar: TPythonDelphiVar
    Engine = PyEngine
    Module = '__main__'
    VarName = 'FuncResult'
    Left = 664
    Top = 344
  end
  object OpenDlg: TOpenTextFileDialog
    Filter = 'Python Script File|*.py'
    Left = 592
    Top = 8
  end
  object ClassDelphiVar: TPythonDelphiVar
    Engine = PyEngine
    Module = '__main__'
    VarName = 'ClassVar'
    OnExtGetData = ClassDelphiVarExtGetData
    OnExtSetData = ClassDelphiVarExtSetData
    Left = 552
    Top = 107
  end
  object ArrayDelphiVar: TPythonDelphiVar
    Engine = PyEngine
    Module = '__main__'
    VarName = 'ArrayVar'
    Left = 560
    Top = 227
  end
end
