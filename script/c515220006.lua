--Meklord Takeover
function c515220006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c515220006.target)
	e1:SetOperation(c515220006.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c515220006.efilter)
	c:RegisterEffect(e2)
	--Untargetable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c515220006.immtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--Indes
	local e4=e2:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c515220006.tgvalue)
	c:RegisterEffect(e4)
end
function c515220006.efilter(e,re,c)
	 local rc=re:GetHandler()
    return e:GetOwnerPlayer()==re:GetOwnerPlayer() and re:IsActiveType(TYPE_MONSTER)
        and c~=re:GetOwner() and rc:IsSetCard(0x3013)
end
function c515220006.immtg(e,c)
	return c:IsSetCard(0x3013)
end
function c515220006.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c515220006.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c515220006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c515220006.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c515220006.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCountFromEx(tp)>0) or not (e:GetHandler():IsRelateToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c515220006.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
	and Duel.GetControl(tc,1-tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			if Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)>0 and Duel.SelectYesNo(tp,515220006,0) then
			local dc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Destroy(dc,REASON_EFFECT)
		end
	end
end