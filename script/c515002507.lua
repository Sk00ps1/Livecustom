--The Second Eye of Timaeus
--designed and scripted by Larry126
function c515002507.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,515002507)
	e1:SetCost(c515002507.cost)
	e1:SetTarget(c515002507.target)
	e1:SetOperation(c515002507.activate)
	c:RegisterEffect(e1)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetValue(10000050)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(515002507,ACTIVITY_SUMMON,c515002507.counterfilter)
	Duel.AddCustomActivityCounter(515002507,ACTIVITY_SPSUMMON,c515002507.counterfilter)
end
c515002507.card_code_list={46986414,515002507}
function c515002507.counterfilter(c)
	return c:IsCode(46986414)
end
function c515002507.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(515002507,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(515002507,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetLabelObject(e)
	e2:SetTarget(c515002507.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c515002507.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject() and not c:IsCode(46986414)
end
function c515002507.tgfilter(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCanBeFusionMaterial()
		and c:IsSetCard(0x10a2) and Duel.GetLocationCountFromEx(tp,tp,c)>0 and not c:IsImmuneToEffect(e)
		and Duel.IsExistingMatchingCard(c515002507.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c515002507.spfilter(c,e,tp,code)
	return aux.IsMaterialListCode(c,code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c515002507.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515002507.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c515002507.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c515002507.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c515002507.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g:GetFirst():GetCode())
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(g:GetFirst()))
			Duel.SendtoGrave(g:GetFirst(),REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1,true)
			sc:RegisterFlagEffect(515002507,RESET_EVENT+0x1fe0000,0,1)
			sc:CompleteProcedure()
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetLabelObject(sc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetCondition(c515002507.descon)
			e2:SetOperation(c515002507.desop)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_CODE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(46986414)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e3)
		end
	end
end
function c515002507.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(515002507)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c515002507.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
