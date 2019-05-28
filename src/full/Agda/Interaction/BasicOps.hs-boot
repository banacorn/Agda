module Agda.Interaction.BasicOps where

import Agda.Syntax.Abstract (Expr)
import Agda.Syntax.Common (InteractionId)
import  {-# SOURCE #-} Agda.TypeChecking.Monad.Base (NamedMeta)

data OutputConstraint a b
type Goals = ( [OutputConstraint Expr InteractionId] -- visible metas
             , [OutputConstraint Expr NamedMeta]     -- hidden metas
             )