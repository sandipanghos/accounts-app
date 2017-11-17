'use strict'

`import { encodeParams } from '../../core/utils.js'`
`import { isUrl } from '../../core/url.js'`
`import { isAuth0Hosted,  redirectToAuth0} from '../../core/auth.js'`

LoginController = (
  $log
  $state
  $stateParams
) ->
  
  vm = this
  
  isConnectLogin = ->
    if isAuth0Hosted()
      # check the current clietn_id to see if it's connect
      app = window?.config?.dict?.signin?.title
      return app && app.toLowerCase() == 'connect'
    else
      # checking with app parameter
      app = $stateParams.app
      if app
        $log.info 'app: '+app
        return app.toLowerCase() == 'connect'

      # checking with return url
      retUrl = $stateParams.retUrl
      if retUrl && isUrl retUrl
        parser = document?.createElement 'a'
        if parser
          parser.href = retUrl
          return parser.hostname.toLowerCase().startsWith('connect.')
    
    false
  
  init = ->
    redirectToAuth0($stateParams)
    if isConnectLogin()
      $state.go 'CONNECT_LOGIN', encodeParams $stateParams
    else
      $state.go 'MEMBER_LOGIN', encodeParams $stateParams
    vm
  
  init()


LoginController.$inject = [
  '$log'
  '$state'
  '$stateParams'
]

angular.module('accounts').controller 'LoginController', LoginController
